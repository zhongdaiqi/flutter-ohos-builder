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
TEE_PID=$!

# `tee` lives in a subshell, so on any exit path - including failures under `set -e` -
# give it a bounded window to drain before the container tears down, or the tail of
# the log is lost. The bound is essential: hvigor/node daemons inherit our stdout
# (the pipe into tee) and can keep it open forEVER after this script dies, and since
# the entrypoint is PID 1, an unbounded `wait` here hangs the whole job until the
# runner-level timeout (observed: 85 silent minutes in run 37985171560).
TEE_PID=""
cleanup() {
    sync
    if [[ -z "${TEE_PID}" ]]; then
        for d in /proc/[0-9]*; do
            if tr '\0' ' ' < "${d}/cmdline" 2>/dev/null | grep -q "tee -a ${LOG_FILE}"; then
                TEE_PID="${d#/proc/}"
                break
            fi
        done
    fi
    if [[ -n "${TEE_PID}" ]] && kill -0 "${TEE_PID}" 2>/dev/null; then
        for _ in $(seq 1 15); do
            kill -0 "${TEE_PID}" 2>/dev/null || break
            sleep 1
        done
        kill -9 "${TEE_PID}" 2>/dev/null || true
    fi
    wait 2>/dev/null || true
}
trap cleanup EXIT

# Parse args
FLUTTER_VERSION=""
OHOS_API=""
BUILD_MODE="release"
BUILD_TARGET="app"
PROJECT_PATH="."
BUNDLE_NAME=""
APP_NAME=""
OHOS_SIGN_ENABLED="false"
OHOS_SIGN_ALG="SHA256withECDSA"
OHOS_SIGN_KEY_ALIAS=""
OHOS_SIGN_KEY_PASSWORD=""
OHOS_SIGN_STORE_PASSWORD=""
OHOS_SIGN_CERT_BASE64=""
OHOS_SIGN_PROFILE_BASE64=""
OHOS_SIGN_STORE_FILE_BASE64=""
OHOS_SIGN_MATERIAL_BASE64=""
ANDROID_SIGN_ENABLED="false"
ANDROID_SIGN_KEY_ALIAS=""
ANDROID_SIGN_KEY_PASSWORD=""
ANDROID_SIGN_STORE_BASE64=""
ANDROID_SIGN_STORE_PASSWORD=""
ANDROID_SIGN_DIR=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --flutter-version) FLUTTER_VERSION="$2"; shift 2;;
        --ohos-api) OHOS_API="$2"; shift 2;;
        --build-mode) BUILD_MODE="$2"; shift 2;;
        --build-target) BUILD_TARGET="$2"; shift 2;;
        --project-path) PROJECT_PATH="$2"; shift 2;;
        --bundle-name) BUNDLE_NAME="$2"; shift 2;;
        --app-name) APP_NAME="$2"; shift 2;;
        --ohos-sign-enabled) OHOS_SIGN_ENABLED="$2"; shift 2;;
        --ohos-sign-alg) OHOS_SIGN_ALG="$2"; shift 2;;
        --ohos-sign-key-alias) OHOS_SIGN_KEY_ALIAS="$2"; shift 2;;
        --ohos-sign-key-password) OHOS_SIGN_KEY_PASSWORD="$2"; shift 2;;
        --ohos-sign-store-password) OHOS_SIGN_STORE_PASSWORD="$2"; shift 2;;
        --ohos-sign-cert-base64) OHOS_SIGN_CERT_BASE64="$2"; shift 2;;
        --ohos-sign-profile-base64) OHOS_SIGN_PROFILE_BASE64="$2"; shift 2;;
        --ohos-sign-store-file-base64) OHOS_SIGN_STORE_FILE_BASE64="$2"; shift 2;;
        --ohos-sign-material-base64) OHOS_SIGN_MATERIAL_BASE64="$2"; shift 2;;
        --android-sign-enabled) ANDROID_SIGN_ENABLED="$2"; shift 2;;
        --android-sign-key-alias) ANDROID_SIGN_KEY_ALIAS="$2"; shift 2;;
        --android-sign-key-password) ANDROID_SIGN_KEY_PASSWORD="$2"; shift 2;;
        --android-sign-store-base64) ANDROID_SIGN_STORE_BASE64="$2"; shift 2;;
        --android-sign-store-password) ANDROID_SIGN_STORE_PASSWORD="$2"; shift 2;;
        *) echo "Unknown arg: $1"; exit 1;;
    esac
done

# Never let the credentials reach the log, even by accident: report their length only.
mask_len() { local v="${1:-}"; echo "${#v} characters"; }

dump_profile_redacted() {
    perl -pe 's/("(?:keyPassword|storePassword)"\s*:\s*)"[^"]*"/$1"******"/g' "${1}"
}

build_android_signing() {
    ANDROID_SIGN_DIR="/tmp/android-sign"
    rm -rf "${ANDROID_SIGN_DIR}"
    mkdir -p "${ANDROID_SIGN_DIR}"

    if [[ -z "${ANDROID_SIGN_STORE_BASE64}" ]]; then
        echo "ERROR: android keystore (android-sign-store-base64) is empty."
        return 1
    fi

    printf '%s' "${ANDROID_SIGN_STORE_BASE64}" | base64 -d > "${ANDROID_SIGN_DIR}/keystore.jks" \
        || { echo "ERROR: android keystore is not valid base64."; return 1; }
    echo "  ${ANDROID_SIGN_DIR}/keystore.jks: $(wc -c < "${ANDROID_SIGN_DIR}/keystore.jks") bytes"

    KEYPROPS_FILE="android/key.properties"
    cat > "${KEYPROPS_FILE}" <<EOF
storePassword=${ANDROID_SIGN_STORE_PASSWORD}
keyPassword=${ANDROID_SIGN_KEY_PASSWORD}
keyAlias=${ANDROID_SIGN_KEY_ALIAS}
storeFile=${ANDROID_SIGN_DIR}/keystore.jks
EOF

    echo "[Android] Wrote ${KEYPROPS_FILE}"
    echo "[Android] Keystore path = ${ANDROID_SIGN_DIR}/keystore.jks"
}

# CLI summary

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
echo "OHOS signing enabled: ${OHOS_SIGN_ENABLED}"
if [[ "${OHOS_SIGN_ENABLED}" == "true" ]]; then
    echo "  signAlg: ${OHOS_SIGN_ALG}"
    echo "  keyAlias: ${OHOS_SIGN_KEY_ALIAS}"
    echo "  keyPassword: $(mask_len "${OHOS_SIGN_KEY_PASSWORD}")"
    echo "  storePassword: $(mask_len "${OHOS_SIGN_STORE_PASSWORD}")"
    echo "  cert (.cer) base64: $(mask_len "${OHOS_SIGN_CERT_BASE64}")"
    echo "  profile (.p7b) base64: $(mask_len "${OHOS_SIGN_PROFILE_BASE64}")"
    echo "  keystore (.p12) base64: $(mask_len "${OHOS_SIGN_STORE_FILE_BASE64}")"
    echo "  sign material zip base64: $(mask_len "${OHOS_SIGN_MATERIAL_BASE64}")"
fi
echo "Android signing enabled: ${ANDROID_SIGN_ENABLED}"
if [[ "${ANDROID_SIGN_ENABLED}" == "true" ]]; then
    echo "  Android keyAlias: ${ANDROID_SIGN_KEY_ALIAS}"
    echo "  Android keyPassword: $(mask_len "${ANDROID_SIGN_KEY_PASSWORD}")"
    echo "  Android storePassword: $(mask_len "${ANDROID_SIGN_STORE_PASSWORD}")"
    echo "  Android keystore base64: $(mask_len "${ANDROID_SIGN_STORE_BASE64}")"
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

# Step 2: Android signing first if target is Android
if [[ "${BUILD_TARGET}" == "android" && "${ANDROID_SIGN_ENABLED}" == "true" ]]; then
    echo "[2/4] Preparing Android signing material..."
    build_android_signing
fi

# Step 3: Ensure ohos platform exists, then install dependencies
if [[ "${BUILD_TARGET}" != "android" ]]; then
    echo "[3/4] Installing dependencies..."
    if [[ ! -d "ohos" ]]; then
        PROJECT_NAME="$(grep -m1 '^name:' pubspec.yaml | sed 's/^name:[[:space:]]*//' | tr -d '[:space:]')"
        PROJECT_NAME="${PROJECT_NAME:-app}"
        echo "ohos/ platform not found, generating via: flutter create --platforms=ohos --project-name=${PROJECT_NAME} ."
        flutter create --platforms=ohos --project-name="${PROJECT_NAME}" .
    fi
    flutter pub get
fi

# Android build path (default unsigned unless signing is enabled)
if [[ "${BUILD_TARGET}" == "android" ]]; then
    echo "[3/4] Building Android target..."
    if [[ "${ANDROID_SIGN_ENABLED}" == "true" ]]; then
        flutter build apk --release < /dev/null
        FLUTTER_RC=$?
        ARTIFACT_GLOB="build/app/outputs/flutter-apk/*.apk"
    else
        flutter build apk --debug < /dev/null
        FLUTTER_RC=$?
        ARTIFACT_GLOB="build/app/outputs/flutter-apk/*.apk"
    fi

    echo "[3/4] flutter build exited with code ${FLUTTER_RC}"
    if [[ -n "${ANDROID_SIGN_DIR:-}" ]]; then
        rm -rf "${ANDROID_SIGN_DIR}"
    fi
    if [[ -f "android/key.properties" ]]; then
        rm -f "android/key.properties"
    fi

    echo "[4/4] Locating Android artifact..."
    ARTIFACT_PATH="$(ls ${ARTIFACT_GLOB} 2>/dev/null | head -1)"
    if [[ -z "${ARTIFACT_PATH}" ]]; then
        echo "ERROR: No Android artifact found at ${ARTIFACT_GLOB}"
        find build -type f \( -name '*.apk' -o -name '*.aab' \) 2>/dev/null || echo "  (none found)"
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
    sync || true
    exit 0
fi

# Step 2.2: App identity for OHOS builds
APP_JSON="ohos/AppScope/app.json5"
if [[ -n "${BUNDLE_NAME}" ]]; then
    echo "[3/4] Setting bundleName -> ${BUNDLE_NAME}"
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
    echo "[3/4] Setting app name -> ${APP_NAME}"
    if [[ -f "${APP_SCOPE_STRINGS}" ]]; then
        perl -0777 -i -pe "s/(\"name\"\s*:\s*\"app_name\"[\s\S]*?\"value\"\s*:\s*\")[^\"]*(\")/\${1}${APP_NAME}\${2}/g" "${APP_SCOPE_STRINGS}"
    else
        echo "WARNING: ${APP_SCOPE_STRINGS} not found; app name left untouched."
    fi
    echo "--- ${APP_SCOPE_STRINGS} ---"
    cat "${APP_SCOPE_STRINGS}"
fi

if [[ "${OHOS_SIGN_ENABLED}" == "true" ]] && [[ -z "${BUNDLE_NAME}" ]]; then
    echo "[3/4] WARNING: signing is enabled but no bundle-name was supplied."
    echo "         The generated bundleName is whatever flutter create produced"
    echo "         (derived from the project name) - it must match your .p7b."
    echo "--- ${APP_JSON} (as generated) ---"
    cat "${APP_JSON}" 2>/dev/null || true
fi

# Step 2.5: Pin compileSdkVersion to the SDK embedded in this image.
BUILD_PROFILE="ohos/build-profile.json5"
if [[ -f "${BUILD_PROFILE}" ]]; then
    COMPILE_SDK="$(jq -r '.data.platformVersion // empty' "${DEVECO_SDK_HOME:-/opt/ohos-sdk/sdk}/default/sdk-pkg.json" 2>/dev/null || true)"
    if [[ -n "${COMPILE_SDK}" ]]; then
        if grep -q 'compileSdkVersion' "${BUILD_PROFILE}"; then
            echo "[3/4] compileSdkVersion already present in ${BUILD_PROFILE}, leaving it alone."
        else
            echo "[3/4] Injecting \"compileSdkVersion\": \"${COMPILE_SDK}\" into ${BUILD_PROFILE}"
            perl -0pi -e "s{(\"compatibleSdkVersion\"\s*:\s*\"[^\"]*\",)}{\"compileSdkVersion\": \"${COMPILE_SDK}\",\n        \$1}g" "${BUILD_PROFILE}"
        fi
        echo "--- ${BUILD_PROFILE} (products section) ---"
        sed -n '/"products"/,/\]/p' "${BUILD_PROFILE}"
    else
        echo "[3/4] WARNING: could not read platformVersion from sdk-pkg.json; leaving ${BUILD_PROFILE} untouched."
    fi
else
    echo "[3/4] ${BUILD_PROFILE} not found, skipping compileSdkVersion injection."
fi

# Step 2.7: OHOS signing material
SIGN_DIR="/tmp/ohos-sign"
if [[ "${OHOS_SIGN_ENABLED}" == "true" ]]; then
    echo "[3/4] Writing OHOS signing material..."
    rm -rf "${SIGN_DIR}"
    mkdir -p "${SIGN_DIR}"

    write_material() {
        local label="$1" dest="$2" payload="$3"
        if [[ -z "${payload}" ]]; then
            echo "ERROR: ${label} is empty - supply it through the corresponding ohos-sign-* input."
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

    write_material "cert (.cer)"      "${SIGN_DIR}/app.cer" "${OHOS_SIGN_CERT_BASE64}"
    write_material "profile (.p7b)"   "${SIGN_DIR}/app.p7b" "${OHOS_SIGN_PROFILE_BASE64}"
    write_material "keystore (.p12)"  "${SIGN_DIR}/app.p12" "${OHOS_SIGN_STORE_FILE_BASE64}"

    if [[ -z "${OHOS_SIGN_MATERIAL_BASE64}" ]]; then
        echo "ERROR: sign material is missing - supply it through the ohos-sign-material-base64 input."
        exit 1
    fi
    printf '%s' "${OHOS_SIGN_MATERIAL_BASE64}" | base64 -d > "${SIGN_DIR}/material.zip" \
        || { echo "ERROR: sign material is not valid base64."; exit 1; }
    unzip -o -q "${SIGN_DIR}/material.zip" -d "${SIGN_DIR}" \
        || { echo "ERROR: sign material is not a valid zip (expected a material/ dir at the root)."; exit 1; }
    if [[ ! -d "${SIGN_DIR}/material" ]]; then
        echo "ERROR: the zip must contain a material/ directory at its root."
        exit 1
    fi
    echo "  ${SIGN_DIR}/material: $(find "${SIGN_DIR}/material" -type f | wc -l) files"

    if [[ ! -f "${BUILD_PROFILE}" ]]; then
        echo "ERROR: signing enabled but ${BUILD_PROFILE} does not exist."
        exit 1
    fi

    if grep -q '"certpath"' "${BUILD_PROFILE}"; then
        echo "[3/4] signingConfigs already populated in ${BUILD_PROFILE}, leaving it as-is."
    else
        cat > "${SIGN_DIR}/signing_block.txt" <<EOB
    "signingConfigs": [
      {
        "name": "default",
        "type": "HarmonyOS",
        "material": {
          "certpath": "${SIGN_DIR}/app.cer",
          "keyAlias": "${OHOS_SIGN_KEY_ALIAS}",
          "keyPassword": "${OHOS_SIGN_KEY_PASSWORD}",
          "profile": "${SIGN_DIR}/app.p7b",
          "signAlg": "${OHOS_SIGN_ALG}",
          "storeFile": "${SIGN_DIR}/app.p12",
          "storePassword": "${OHOS_SIGN_STORE_PASSWORD}"
        }
      }
    ],
EOB
        export SIGN_BLOCK_FILE="${SIGN_DIR}/signing_block.txt"
        perl -0777 -i -pe '
            BEGIN { local $/; open my $fh, "<", $ENV{SIGN_BLOCK_FILE}
                    or die "cannot read signing block: $!"; $SIGN_BLOCK = <$fh>; }
            s/"signingConfigs"\s*:\s*\[\]\s*,?/$SIGN_BLOCK/e;
        ' "${BUILD_PROFILE}"

        if grep -q '"certpath"' "${BUILD_PROFILE}"; then
            echo "[3/4] signingConfigs injected into ${BUILD_PROFILE}"
        else
            echo "ERROR: could not inject signingConfigs into ${BUILD_PROFILE}."
            echo "       The expected anchor \"signingConfigs\": [] was not found."
            echo "----- ${BUILD_PROFILE} -----"
            dump_profile_redacted "${BUILD_PROFILE}"
            exit 1
        fi

        if grep -qE '^[[:space:]]*,[[:space:]]*$' "${BUILD_PROFILE}"; then
            echo "ERROR: ${BUILD_PROFILE} contains a stray comma line - injection malformed the JSON5."
            echo "----- ${BUILD_PROFILE} -----"
            dump_profile_redacted "${BUILD_PROFILE}"
            exit 1
        fi
    fi

    echo "--- ${BUILD_PROFILE} (passwords redacted) ---"
    dump_profile_redacted "${BUILD_PROFILE}"
else
    if [[ "${BUILD_MODE}" == "release" ]]; then
        echo "[3/4] WARNING: release build WITHOUT signing configuration."
        echo "         hvigor cannot produce a signed ${BUILD_TARGET} unless signingConfigs is filled in."
        echo "         Either pass the ohos-sign-* inputs, or build with --build-mode debug."
    fi
fi

# Step 3: Build
if [[ "${BUILD_TARGET}" == "app" ]]; then
    echo "[4/4] Building OHOS app (${BUILD_MODE})..."
    flutter build app --"${BUILD_MODE}" < /dev/null
    FLUTTER_RC=$?
    ARTIFACT_GLOB="ohos/build/outputs/default/*.app"
elif [[ "${BUILD_TARGET}" == "hap" ]]; then
    echo "[4/4] Building OHOS hap (${BUILD_MODE})..."
    flutter build hap --"${BUILD_MODE}" < /dev/null
    FLUTTER_RC=$?
    ARTIFACT_GLOB="ohos/entry/build/default/outputs/default/*.hap"
else
    echo "ERROR: Unknown build target: ${BUILD_TARGET}"
    exit 1
fi

echo "[4/4] flutter build exited with code ${FLUTTER_RC}"
rm -rf "${SIGN_DIR}"

ARTIFACT_PATH="$(ls ${ARTIFACT_GLOB} 2>/dev/null | head -1)"
if [[ -z "${ARTIFACT_PATH}" ]]; then
    echo "ERROR: No artifact found at ${ARTIFACT_GLOB}"
    echo "Listing outputs:"
    find ohos -type f \( -name '*.hap' -o -name '*.app' \) 2>/dev/null || echo "  (none found)"
    exit 1
fi

if [[ "${BUILD_MODE}" == "release" && "${FLUTTER_RC}" != "0" ]]; then
    echo "ERROR: release build exited with code ${FLUTTER_RC}; refusing to report success."
    exit "${FLUTTER_RC}"
fi
if [[ "${FLUTTER_RC}" != "0" ]]; then
    echo "NOTE: flutter exited with code ${FLUTTER_RC} (debug signing notice), "
    echo "      but the unsigned artifact was produced - treating as success."
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
sync || true
