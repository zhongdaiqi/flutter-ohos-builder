#!/usr/bin/env bash
set -euo pipefail

# Mirror everything into a log file inside the working directory.
#
# With `uses:` (docker action) the project root is mounted at /github/workspace,
# which is the runner's $GITHUB_WORKSPACE - so anything written here survives as an
# Actions artifact. That matters because job LOGS are not retrievable through the
# REST API for tokens without actions:read, leaving failures otherwise unreadable.
LOG_FILE="flutter-ohos-build.log"
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

while [[ $# -gt 0 ]]; do
    case $1 in
        --flutter-version) FLUTTER_VERSION="$2"; shift 2;;
        --ohos-api) OHOS_API="$2"; shift 2;;
        --build-mode) BUILD_MODE="$2"; shift 2;;
        --build-target) BUILD_TARGET="$2"; shift 2;;
        --project-path) PROJECT_PATH="$2"; shift 2;;
        *) echo "Unknown arg: $1"; exit 1;;
    esac
done

echo "================================"
echo "  Flutter OHOS Builder"
echo "================================"
echo "Flutter version: ${FLUTTER_VERSION}"
echo "OHOS API: ${OHOS_API}"
echo "Build mode: ${BUILD_MODE}"
echo "Build target: ${BUILD_TARGET}"
echo "Project path: ${PROJECT_PATH}"
echo "================================"

cd "${PROJECT_PATH}"

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
