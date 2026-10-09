#!/usr/bin/env bash
set -euo pipefail

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

echo "::set-output name=artifact-path::${ARTIFACT_PATH}"
