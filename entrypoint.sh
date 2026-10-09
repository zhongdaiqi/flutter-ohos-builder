#!/usr/bin/env bash
set -euo pipefail

# Mirror everything into a log file inside the working directory.
#
# With `uses:` (docker action) the project root is mounted at /github/workspace,
# which is the runner's $GITHUB_WORKSPACE - so anything written here survives as an
# Actions artifact. That matters because job LOGS are not retrievable through the
# REST API for tokens without actions:read, leaving failures otherwise unreadable.
# Resolve the workspace the SAME way for both invocations styles:
#   - docker action (`uses:`): GITHUB_WORKSPACE is set and points at /github/workspace,
#     which is the runner's real workspace and therefore survives as an Actions artifact.
#   - plain `docker run`: fall back to whatever directory we were started in.
# Using an absolute path matters: if the log were opened relative to the container's
# initial CWD and that CWD is not the workspace, the whole log vanishes instead of
# landing somewhere we can read it afterwards.
WORKSPACE_DIR="${GITHUB_WORKSPACE:-}"
[[ -z "${WORKSPACE_DIR}" ]] && WORKSPACE_DIR="$(pwd)"
LOG_FILE="${WORKSPACE_DIR}/flutter-ohos-build.log"
touch "${LOG_FILE}" 2>/dev/null || LOG_FILE="$(pwd)/flutter-ohos-build.log"
exec > >(tee -a "${LOG_FILE}") 2>&1

# `tee` lives in a subshell, so on any exit path - including failures under `set -e` -
# wait for it to drain before the container tears down, or the tail of the log is lost.
cleanup() { wait; sync; }
trap cleanup EXIT

# Parse args
FLUTTER_VERSION=""
OHOS_API=""
BUILD_MODE="release"
BUILD_TARGET="app"
PROJECT_PATH="."
BUNDLE_NAME=""
APP_NAME=""
SIGN_ENABLED="false"
SIGN_ALG="SHA256withECDSA"
SIGN_KEY_ALIAS=""
SIGN_KEY_PASSWORD=""
SIGN_STORE_PASSWORD=""
SIGN_CERT_BASE64=""
SIGN_PROFILE_BASE64=""
SIGN_STORE_BASE64=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --flutter-version) FLUTTER_VERSION="$2"; shift 2;;
        --ohos-api) OHOS_API="$2"; shift 2;;
        --build-mode) BUILD_MODE="$2"; shift 2;;
        --build-target) BUILD_TARGET="$2"; shift 2;;
        --project-path) PROJECT_PATH="$2"; shift 2;;
        --bundle-name) BUNDLE_NAME="$2"; shift 2;;
        --app-name) APP_NAME="$2"; shift 2;;
        --sign-enabled) SIGN_ENABLED="$2"; shift 2;;
        --sign-alg) SIGN_ALG="$2"; shift 2;;
        --sign-key-alias) SIGN_KEY_ALIAS="$2"; shift 2;;
        --sign-key-password) SIGN_KEY_PASSWORD="$2"; shift 2;;
        --sign-store-password) SIGN_STORE_PASSWORD="$2"; shift 2;;
        --sign-cert-base64) SIGN_CERT_BASE64="$2"; shift 2;;
        --sign-profile-base64) SIGN_PROFILE_BASE64="$2"; shift 2;;
        --sign-store-file-base64) SIGN_STORE_BASE64="$2"; shift 2;;
        *) echo "Unknown arg: $1"; exit 1;;
    esac
done

# Never let the credentials reach the log, even by accident: report their length only.
mask_len() { local v="${1:-}"; echo "${#v} characters"; }

echo "================================"
echo "  Flutter OHOS Builder"
echo "================================"
echo "Flutter version: ${FLUTTER_VERSION}"
echo "OHOS API: ${OHOS_API}"
echo "Build mode: ${BUILD_MODE}"
echo "Build target: ${BUILD_TARGET}"
echo "Project path: ${PROJECT_PATH}"
echo "bundleName: ${BUNDLE_NAME:-(not set - keep whatever flutter create generated)}"
echo "appName: ${APP_NAME:-(not set)}"
echo "Signing enabled: ${SIGN_ENABLED}"
if [[ "${SIGN_ENABLED}" == "true" ]]; then
    echo "  signAlg: ${SIGN_ALG}"
    echo "  keyAlias: ${SIGN_KEY_ALIAS}"
    echo "  keyPassword: $(mask_len "${SIGN_KEY_PASSWORD}")"
    echo "  storePassword: $(mask_len "${SIGN_STORE_PASSWORD}")"
    echo "  cert (.cer) base64: $(mask_len "${SIGN_CERT_BASE64}")"
    echo "  profile (.p7b) base64: $(mask_len "${SIGN_PROFILE_BASE64}")"
    echo "  keystore (.p12) base64: $(mask_len "${SIGN_STORE_BASE64}")"
fi
echo "Workspace: ${WORKSPACE_DIR}"
echo "Log file: ${LOG_FILE}"
echo "================================"

# Resolve relative paths against the workspace, not against whatever CWD docker gave us.
if [[ "${PROJECT_PATH}" = /* ]]; then
    cd "${PROJECT_PATH}"
else
    cd "${WORKSPACE_DIR}/${PROJECT_PATH}"
fi
echo "Working dir: $(pwd)"
ls -la

# Step 1: Flutter environment check
echo "[1/4] Checking Flutter environment..."
flutter --version
echo "HarmonyOS SDK (DEVECO_SDK_HOME=${DEVECO_SDK_HOME:-unset}):"
cat "${DEVECO_SDK_HOME:-/opt/ohos-sdk/sdk}/default/sdk-pkg.json" 2>/dev/null || echo "  (sdk-pkg.json not readable)"
echo "hvigor: $(hvigorw -v 2>/dev/null || echo unknown)"
echo "flutter doctor:"
flutter doctor -v || true

# Step 2: Ensure ohos platform exists, then install dependencies
echo "[2/4] Installing dependencies..."
if [[ ! -d "ohos" ]]; then
    PROJECT_NAME="$(grep -m1 '^name:' pubspec.yaml | sed 's/^name:[[:space:]]*//' | tr -d '[:space:]')"
    PROJECT_NAME="${PROJECT_NAME:-app}"
    echo "ohos/ platform not found, generating via: flutter create --platforms=ohos --project-name=${PROJECT_NAME} ."
    flutter create --platforms=ohos --project-name="${PROJECT_NAME}" .
fi
flutter pub get

# Step 2.2: App identity
#
# bundleName matters twice over: it is the app's identity on device, and the .p7b
# provisioning profile is issued against exactly one bundleName. If the two differ,
# hvigor refuses to sign, so when signing is on we make sure the override happened.
APP_JSON="ohos/AppScope/app.json5"
if [[ -n "${BUNDLE_NAME}" ]]; then
    echo "[2.2/4] Setting bundleName -> ${BUNDLE_NAME}"
    if [[ -f "${APP_JSON}" ]]; then
        perl -0777 -i -pe "s/(\"bundleName\"\s*:\s*\")[^\"]*(\")/\${1}${BUNDLE_NAME}\${2}/g" "${APP_JSON}"
    else
        echo "WARNING: ${APP_JSON} not found; bundleName left untouched."
    fi
    echo "--- ${APP_JSON} ---"
    cat "${APP_JSON}"
fi

APP_SCOPE_STRINGS="ohos/AppScope/resources/base/element/string.json"
if [[ -n "${APP_NAME}" ]]; then
    echo "[2.2/4] Setting app name -> ${APP_NAME}"
    if [[ -f "${APP_SCOPE_STRINGS}" ]]; then
        # Anchor on the "app_name" entry instead of smashing every "value" in the file,
        # in case AppScope ever carries more than one string resource.
        perl -0777 -i -pe "s/(\"name\"\s*:\s*\"app_name\"[\s\S]*?\"value\"\s*:\s*\")[^\"]*(\")/\${1}${APP_NAME}\${2}/g" "${APP_SCOPE_STRINGS}"
    else
        echo "WARNING: ${APP_SCOPE_STRINGS} not found; app name left untouched."
    fi
    echo "--- ${APP_SCOPE_STRINGS} ---"
    cat "${APP_SCOPE_STRINGS}"
fi

if [[ "${SIGN_ENABLED}" == "true" ]] && [[ -z "${BUNDLE_NAME}" ]]; then
    echo "[2.2/4] WARNING: signing is enabled but no bundle-name was supplied."
    echo "         The generated bundleName is whatever flutter create produced"
    echo "         (derived from the project name) - it must match your .p7b."
    echo "--- ${APP_JSON} (as generated) ---"
    cat "${APP_JSON}" 2>/dev/null || true
fi

# Step 2.5: Pin compileSdkVersion to the SDK embedded in this image.
#
# The upstream ReleaseNote for 3.41.9/3.41.10-ohos-1.0.1 requires the app to be
# COMPILED against SDK 26.0.0 ("应用编译最低 SDK 26.0.0"), while only its runtime
# floor stays at 5.0.5(17) ("应用运行最低 SDK"). flutter create emits
# build-profile.json5 with compatibleSdkVersion only - no compileSdkVersion - so
# hvigor falls back to whatever the local SDK advertises. Compiling against an
# older SDK (5.1.0.x -> apiVersion 18) blows up in CompileArkTS, because the
# prebuilt Flutter engine har references API-26 symbols:
#     Namespace 'autoFillManager' has no exported member 'AutoFillType'
#
# We read the version straight out of the embedded SDK rather than hardcoding it,
# so the image and the generated project can never drift apart.
BUILD_PROFILE="ohos/build-profile.json5"
if [[ -f "${BUILD_PROFILE}" ]]; then
    COMPILE_SDK="$(jq -r '.data.platformVersion // empty' \
        "${DEVECO_SDK_HOME:-/opt/ohos-sdk/sdk}/default/sdk-pkg.json" 2>/dev/null || true)"
    if [[ -n "${COMPILE_SDK}" ]]; then
        if grep -q 'compileSdkVersion' "${BUILD_PROFILE}"; then
            echo "[2.5/4] compileSdkVersion already present in ${BUILD_PROFILE}, leaving it alone."
        else
            echo "[2.5/4] Injecting \"compileSdkVersion\": \"${COMPILE_SDK}\" into ${BUILD_PROFILE}"
            perl -0pi -e "s{(\"compatibleSdkVersion\"\s*:\s*\"[^\"]*\",)}{\"compileSdkVersion\": \"${COMPILE_SDK}\",\n        \$1}g" \
                "${BUILD_PROFILE}"
        fi
        echo "--- ${BUILD_PROFILE} (products section) ---"
        sed -n '/"products"/,/\]/p' "${BUILD_PROFILE}"
    else
        echo "[2.5/4] WARNING: could not read platformVersion from sdk-pkg.json; leaving ${BUILD_PROFILE} untouched."
    fi
else
    echo "[2.5/4] ${BUILD_PROFILE} not found, skipping compileSdkVersion injection."
fi

# Step 2.7: Signing material
#
# `flutter create` emits ohos/build-profile.json5 with an EMPTY signingConfigs array
# while the product still declares `"signingConfig": "default"` - so any release build
# dies with "signingConfig is not configured" unless the array is filled in.
#
# The three files arrive base64-encoded (repository secrets are text-only) and are
# decoded under /tmp *inside the container*, so they never land in the mounted
# workspace and disappear when the container exits.
SIGN_DIR="/tmp/ohos-sign"
if [[ "${SIGN_ENABLED}" == "true" ]]; then
    echo "[2.7/4] Writing signing material..."
    rm -rf "${SIGN_DIR}"
    mkdir -p "${SIGN_DIR}"

    write_material() {
        local label="$1" dest="$2" payload="$3"
        if [[ -z "${payload}" ]]; then
            echo "ERROR: ${label} is empty - supply it through the corresponding sign-* input."
            return 1
        fi
        printf '%s' "${payload}" | base64 -d > "${dest}" \
            || { echo "ERROR: ${label} is not valid base64."; return 1; }
        local size
        size="$(wc -c < "${dest}")"
        echo "  ${dest}: ${size} bytes ($(file -b "${dest}" 2>/dev/null || echo 'unknown type'))"
        if [[ "${size}" -eq 0 ]]; then
            echo "ERROR: ${dest} decoded to 0 bytes."
            return 1
        fi
    }

    write_material "cert (.cer)"      "${SIGN_DIR}/app.cer" "${SIGN_CERT_BASE64}"
    write_material "profile (.p7b)"   "${SIGN_DIR}/app.p7b" "${SIGN_PROFILE_BASE64}"
    write_material "keystore (.p12)"  "${SIGN_DIR}/app.p12" "${SIGN_STORE_BASE64}"

    if [[ ! -f "${BUILD_PROFILE}" ]]; then
        echo "ERROR: signing enabled but ${BUILD_PROFILE} does not exist."
        exit 1
    fi

    if grep -q '"certpath"' "${BUILD_PROFILE}"; then
        echo "[2.7/4] signingConfigs already populated in ${BUILD_PROFILE}, leaving it as-is."
    else
        cat > "${SIGN_DIR}/signing_block.txt" <<EOB
    "signingConfigs": [
      {
        "name": "default",
        "type": "HarmonyOS",
        "material": {
          "certpath": "${SIGN_DIR}/app.cer",
          "keyAlias": "${SIGN_KEY_ALIAS}",
          "keyPassword": "${SIGN_KEY_PASSWORD}",
          "profile": "${SIGN_DIR}/app.p7b",
          "signAlg": "${SIGN_ALG}",
          "storeFile": "${SIGN_DIR}/app.p12",
          "storePassword": "${SIGN_STORE_PASSWORD}"
        }
      }
    ],
EOB
        export SIGN_BLOCK_FILE="${SIGN_DIR}/signing_block.txt"
        perl -0777 -i -pe '
            BEGIN { local $/; open my $fh, "<", $ENV{SIGN_BLOCK_FILE}
                    or die "cannot read signing block: $!"; $SIGN_BLOCK = <$fh>; }
            # /e makes the replacement an expression, so characters like $ or \
            # inside a password are inserted literally instead of being interpreted.
            s/"signingConfigs"\s*:\s*\[\]/$SIGN_BLOCK/e;
        ' "${BUILD_PROFILE}"

        if grep -q '"certpath"' "${BUILD_PROFILE}"; then
            echo "[2.7/4] signingConfigs injected into ${BUILD_PROFILE}"
        else
            echo "ERROR: could not inject signingConfigs into ${BUILD_PROFILE}."
            echo "       The expected anchor \"signingConfigs\": [] was not found."
            echo "----- ${BUILD_PROFILE} -----"
            cat "${BUILD_PROFILE}"
            exit 1
        fi
    fi

    echo "--- ${BUILD_PROFILE} (passwords redacted) ---"
    perl -pe 's/("(?:keyPassword|storePassword)"\s*:\s*)"[^"]*"/$1"******"/g' "${BUILD_PROFILE}"
else
    if [[ "${BUILD_MODE}" == "release" ]]; then
        echo "[2.7/4] WARNING: release build WITHOUT signing configuration."
        echo "         hvigor cannot produce a signed ${BUILD_TARGET} unless signingConfigs is filled in."
        echo "         Either pass the sign-* inputs, or build with --build-mode debug."
    fi
fi

# Step 3: Build
echo "[3/4] Building ${BUILD_TARGET} (${BUILD_MODE})..."
if [[ "${BUILD_TARGET}" == "app" ]]; then
    flutter build app --"${BUILD_MODE}"
    ARTIFACT_GLOB="ohos/build/outputs/default/*.app"
elif [[ "${BUILD_TARGET}" == "hap" ]]; then
    flutter build hap --"${BUILD_MODE}"
    ARTIFACT_GLOB="ohos/entry/build/default/outputs/default/*.hap"
else
    echo "ERROR: Unknown build target: ${BUILD_TARGET}"
    exit 1
fi

# Step 3.5: the credential files have served their purpose - remove them even though
# /tmp is inside the (ephemeral) container rather than the mounted workspace.
rm -rf "${SIGN_DIR}"

# Step 4: Locate and report artifact
echo "[4/4] Locating build artifact..."
ARTIFACT_PATH="$(ls ${ARTIFACT_GLOB} 2>/dev/null | head -1)"
if [[ -z "${ARTIFACT_PATH}" ]]; then
    echo "ERROR: No artifact found at ${ARTIFACT_GLOB}"
    echo "Listing ohos/build/ outputs:"
    find ohos/build -type f \( -name '*.hap' -o -name '*.app' \) 2>/dev/null || echo "  (none found)"
    exit 1
fi

echo "================================"
echo "  BUILD SUCCESS"
echo "  Artifact: ${ARTIFACT_PATH}"
echo "  Size: $(du -h "${ARTIFACT_PATH}" | cut -f1)"
echo "================================"

if [[ -n "${GITHUB_OUTPUT:-}" ]]; then
    echo "artifact-path=${ARTIFACT_PATH}" >> "${GITHUB_OUTPUT}"
    echo "build-log=${LOG_FILE}" >> "${GITHUB_OUTPUT}"
fi
# `tee` runs in a subshell; make sure it has drained before the container exits.
sync || true
