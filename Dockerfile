FROM ubuntu:22.04

LABEL maintainer="zhongdaiqi"
LABEL description="Flutter + HarmonyOS build environment (HarmonyOS Command Line Tools embedded)"
LABEL org.opencontainers.image.source="https://github.com/zhongdaiqi/flutter-ohos-builder"

ENV DEBIAN_FRONTEND=noninteractive
ENV JAVA_HOME=/opt/jdk-17
ENV NODE_HOME=/opt/node
ENV FLUTTER_HOME=/opt/flutter

# ---------------------------------------------------------------------------
# HarmonyOS Command Line Tools layout
#
# The CLT archive unpacks into a single top-level "command-line-tools/" dir.
# We strip that level so the contents land directly in /opt/ohos-sdk:
#
#   /opt/ohos-sdk/{bin,hvigor,ohpm,sdk,tool,codelinter,hstack,emulator,...}
#
# Everything below is dictated by the shipped scripts, not guessed:
#   bin/hvigorw exports  DEVECO_NODE_HOME=$root/tool/node
#                        DEVECO_SDK_HOME=$root/sdk
#   sdk/default/sdk-pkg.json  -> {"data":{"apiVersion":"18", ...}}
#   flutter_tools' HmosSdk reads DEVECO_SDK_HOME/default/sdk-pkg.json
#   (packages/flutter_tools/lib/src/ohos/ohos_sdk.dart:347-391)
#
# NOTE: /opt/ohos-sdk IS command-line-tools/ itself. The extract must therefore
# REPLACE that path, never `mv` into an already-existing directory - doing so
# nests another command-line-tools/ level and every path below breaks.
# ---------------------------------------------------------------------------
ENV OHOS_HOME=/opt/ohos-sdk
ENV OHOS_SDK_HOME=/opt/ohos-sdk/sdk
ENV HOS_SDK_HOME=/opt/ohos-sdk/sdk
ENV DEVECO_SDK_HOME=/opt/ohos-sdk/sdk
ENV DEVECO_NODE_HOME=/opt/ohos-sdk/tool/node
ENV OHOS_NDK_HOME=/opt/ohos-sdk/sdk/default/openharmony

# Android SDK (required for build-target=android). cmdline-tools + platform-tools are
# installed below; the platforms/build-tools are pinned so an `android` build never has
# to reach out to dl.google.com at run time (same "everything baked in" philosophy as
# the OHOS SDK above). If a future Flutter fork bumps compileSdk beyond what is pinned
# here, entrypoint.sh auto-installs the missing platform via sdkmanager at run time.
ENV ANDROID_HOME=/opt/android-sdk
ENV ANDROID_SDK_ROOT=/opt/android-sdk
ENV PATH=/opt/android-sdk/cmdline-tools/latest/bin:/opt/android-sdk/platform-tools:/opt/ohos-sdk/bin:/opt/ohos-sdk/tool/node/bin:$JAVA_HOME/bin:$NODE_HOME/bin:$FLUTTER_HOME/bin:$PATH

# System dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    git curl unzip p7zip-full xz-utils ca-certificates jq file procps \
    libgl1-mesa-dev libxkbcommon-x11-0 libpulse0 \
    && rm -rf /var/lib/apt/lists/*

# JDK 17 (Adoptium Temurin - always latest GA, redirects to GitHub CDN)
RUN curl -fsSL "https://api.adoptium.net/v3/binary/latest/17/ga/linux/x64/jdk/hotspot/normal/eclipse" \
    | tar xz -C /opt && mv /opt/jdk-17* /opt/jdk-17

# Node.js 18 (Flutter tools need it; the SDK also bundles its own under tool/node)
RUN curl -fsSL https://nodejs.org/dist/v18.20.1/node-v18.20.1-linux-x64.tar.xz \
    | tar xJ -C /opt && mv /opt/node-v18.20.1-linux-x64 /opt/node

# ---------------------------------------------------------------------------
# Android SDK (required only for build-target=android)
#
# Installed at build time so `flutter build apk` has a real Android toolchain and
# never downloads at run time. We pin a spread of platforms/build-tools so the most
# common compileSdk values (34/35/36) are already present; entrypoint.sh installs
# any other compileSdk it detects via sdkmanager (with network) as a safety net.
#
# NOTE: sdkmanager is a Java tool, so this step runs AFTER the JDK above is in place.
# ---------------------------------------------------------------------------
ARG ANDROID_CMDLINE_TOOLS=11076708
RUN set -eux; \
    mkdir -p /opt/android-sdk/cmdline-tools; \
    curl -fsSL --retry 3 --retry-all-errors \
      "https://dl.google.com/android/repository/commandlinetools-linux-${ANDROID_CMDLINE_TOOLS}_latest.zip" \
      -o /tmp/cmdline-tools.zip; \
    unzip -q /tmp/cmdline-tools.zip -d /opt/android-sdk/cmdline-tools; \
    mv /opt/android-sdk/cmdline-tools/cmdline-tools /opt/android-sdk/cmdline-tools/latest; \
    rm -f /tmp/cmdline-tools.zip; \
    yes | sdkmanager --sdk_root=/opt/android-sdk --licenses >/dev/null 2>&1 || true; \
    for pkg in "platform-tools" \
               "platforms;android-34" "platforms;android-35" "platforms;android-36" \
               "build-tools;34.0.0" "build-tools;35.0.0" "build-tools;36.0.0"; do \
        sdkmanager --sdk_root=/opt/android-sdk "$pkg" >/dev/null 2>&1 \
          || echo "WARN: sdkmanager could not install $pkg (may not exist for this cmdline-tools rev) - continuing"; \
    done; \
    yes | sdkmanager --sdk_root=/opt/android-sdk --licenses >/dev/null 2>&1 || true

# ---------------------------------------------------------------------------
# HarmonyOS Command Line Tools (SDK embedded at build time - no download at run time)
#
# Source : zhongdaiqi/command-line-tools-for-hmos (GitHub Releases, mirrors Huawei's
#          "Command Line Tools for HarmonyOS")
# Release: clt-26.0.0.851  ==  Command Line Tools 26.0.0 Release
#          (SDK apiVersion 26 / platformVersion 26.0.0, hvigor 6.26.8)
#
# This version is NOT a guess - it is the one the upstream fork declares mandatory.
# release-notes/Flutter 3.41.9-ohos 1.0.1 ReleaseNote.md (== tag 3.41.10-ohos-1.0.1)
# pins the pairing table as:
#
#   DevEco Studio            : 26.0.0 Release
#   Command Line Tools       : 26.0.0 Release
#   引擎构建最低 SDK         : 26.0.0
#   应用编译最低 SDK         : 26.0.0   -> build-profile.json5 "compileSdkVersion": "26.0.0"
#   应用运行最低 SDK         : 5.0.5(17) -> build-profile.json5 "compatibleSdkVersion"
#
# i.e. the app must be COMPILED against SDK 26 even though the emitted package only
# has to RUN on 5.0.5(17). Building against an older SDK (5.1.0.x => apiVersion 18)
# fails in CompileArkTS: the prebuilt engine har shipped by this Flutter fork is
# itself compiled against API 26 headers, so symbols it references are missing from
# an api-18 SDK. That is exactly why clt-5.1.0.849 failed - the very same
# ReleaseNote lists "支持密码保险箱功能" (autoFill) among the new features, and the
# ArkTS errors were:
#   Namespace 'autoFillManager' has no exported member 'AutoFillType'
#
# The template's compatibleSdkVersion "5.1.0(18)" needs no change: 18 >= 17 is above
# the documented floor. compileSdkVersion is the one that must be injected - see
# entrypoint.sh, which adds it to build-profile.json5 before every build.
#
# The release asset is a 2.34 GB ZIP that GitHub splits into two <=2 GiB parts
# ("commandline-tools-linux-x64-26.0.0.851.part_aa" + ".part_ab"). The split is a
# plain byte cut of one archive - the ZIP64 central directory sits at absolute
# offset 2328363434, past the end of part_aa (1610612736) - so concatenating the
# parts reconstructs the archive exactly.
#
# Uncompressed payload is ~6.75 GB, so the split parts are deleted the moment
# `unzip` is done, before the tree is moved into place.
# ---------------------------------------------------------------------------
ARG CLT_TAG=clt-26.0.0.851
ARG CLT_ASSET=commandline-tools-linux-x64-26.0.0.851
ARG CLT_REPO=zhongdaiqi/command-line-tools-for-hmos
ARG CLT_BASE_URL=https://github.com/${CLT_REPO}/releases/download/${CLT_TAG}
RUN set -eux; \
    mkdir -p /tmp/clt; \
    cd /tmp/clt; \
    curl -fsSL --retry 3 --retry-all-errors -o part_aa "${CLT_BASE_URL}/${CLT_ASSET}.part_aa"; \
    curl -fsSL --retry 3 --retry-all-errors -o part_ab "${CLT_BASE_URL}/${CLT_ASSET}.part_ab"; \
    cat part_aa part_ab > clt.zip; \
    rm -f part_aa part_ab; \
    unzip -q clt.zip -d /tmp/clt/x || { \
        echo "unzip failed - retrying with 7z"; \
        rm -rf /tmp/clt/x; \
        7z x -y -o/tmp/clt/x clt.zip >/dev/null; \
    }; \
    rm -f clt.zip; \
    test -d /tmp/clt/x/command-line-tools; \
    rm -rf /opt/ohos-sdk; \
    mv /tmp/clt/x/command-line-tools /opt/ohos-sdk; \
    rm -rf /tmp/clt

# --- diagnostics: dump the real layout into the build log (never fails; if this
# --- step itself failed it would hide the real cause, so every probe ends with `|| true`)
RUN echo "=== ls -la /opt/ohos-sdk ===";        ls -la /opt/ohos-sdk || true; \
    echo "=== dirs up to depth 2 ===";          find /opt/ohos-sdk -maxdepth 2 -type d 2>/dev/null | sort || true; \
    echo "=== ls -la /opt/ohos-sdk/bin ===";    ls -la /opt/ohos-sdk/bin || true; \
    echo "=== ls -la /opt/ohos-sdk/sdk ===";    ls -la /opt/ohos-sdk/sdk || true; \
    echo "=== ls -la /opt/ohos-sdk/sdk/default ==="; ls -la /opt/ohos-sdk/sdk/default || true; \
    echo "=== sdk-pkg.json (read by flutter_tools) ==="; cat /opt/ohos-sdk/sdk/default/sdk-pkg.json || true; \
    echo "=== cat version.txt ===";             cat /opt/ohos-sdk/version.txt || true; \
    echo "=== hvigor version ===";              cat /opt/ohos-sdk/hvigor/hvigor/package.json | head -5 || true; \
    echo "=== command -v hvigorw ===";          command -v hvigorw || true; \
    echo "=== command -v ohpm ===";             command -v ohpm || true; \
    echo "=== df -h / ===";                     df -h / || true; \
    true

# --- hard assertions --------------------------------------------------------
# Every path below was verified against the ZIP64 central directory of
# clt-26.0.0.851 before this Dockerfile was written, so a failure here means the
# upstream package changed shape - not that the paths were guessed wrong.
RUN test -x /opt/ohos-sdk/bin/hvigorw && test -x /opt/ohos-sdk/bin/ohpm \
    && echo "ASSERT OK: bin/hvigorw and bin/ohpm are present and executable"

# Regression guard for the bug that broke the first clt-26.0.0.851 attempt:
# `mv src /opt/ohos-sdk` where /opt/ohos-sdk already existed put the tree one
# level too deep (nested /opt/ohos-sdk/command-line-tools/...).
RUN test ! -e /opt/ohos-sdk/command-line-tools \
    && echo "ASSERT OK: no nested command-line-tools/ level under /opt/ohos-sdk"

RUN test -f /opt/ohos-sdk/sdk/default/sdk-pkg.json \
    && echo "ASSERT OK: sdk/default/sdk-pkg.json (apiVersion) exists"

RUN test -f /opt/ohos-sdk/hvigor/hvigor/package.json \
    && test -f /opt/ohos-sdk/hvigor/bin/hvigorw.js \
    && echo "ASSERT OK: hvigor runtime is present"

# --- Android SDK sanity checks --------------------------------------------
RUN echo "=== sdkmanager version ==="; sdkmanager --version || true; \
    echo "=== installed Android packages ==="; \
    sdkmanager --sdk_root=/opt/android-sdk --list_installed 2>/dev/null | grep -E 'Android SDK|platforms|build-tools' || true; \
    test -x /opt/android-sdk/cmdline-tools/latest/bin/sdkmanager \
      && echo "ASSERT OK: sdkmanager is present and executable"; \
    test -d /opt/android-sdk/platforms/android-35 \
      && echo "ASSERT OK: platforms;android-35 present (covers Flutter 3.41 default compileSdk)"

# ---------------------------------------------------------------------------
# Flutter OHOS fork (zhongdaiqi/flutter_flutter, synced from gitcode CPF-Flutter/flutter_flutter)
# NOTE: must clone a TAG (not branch) - the flutter tool derives its version from
# `git describe`; a depth-1 branch clone has no tags and reports "0.0.0-unknown",
# which breaks pub version solving.
# ---------------------------------------------------------------------------
ARG FLUTTER_OHOS_TAG=3.41.10-ohos-1.0.1
RUN git clone --depth 1 -b ${FLUTTER_OHOS_TAG} \
    https://github.com/zhongdaiqi/flutter_flutter.git /opt/flutter

# --- tool usability ---------------------------------------------------------
RUN hvigorw -v && ohpm -v

# Report the SDK <-> project-template pairing that this image implies. The
# template's compatibleSdkVersion is what hvigor will ask the SDK for, so print
# both numbers side by side; a mismatch is visible right here in the build log
# instead of surfacing later as an opaque hvigor error.
RUN echo "--- compatibility summary ---"; \
    echo "SDK apiVersion      : $(jq -r '.data.apiVersion' /opt/ohos-sdk/sdk/default/sdk-pkg.json 2>/dev/null || echo '?')"; \
    echo "SDK platformVersion : $(jq -r '.data.platformVersion' /opt/ohos-sdk/sdk/default/sdk-pkg.json 2>/dev/null || echo '?')"; \
    echo "SDK displayName     : $(jq -r '.data.displayName' /opt/ohos-sdk/sdk/default/sdk-pkg.json 2>/dev/null || echo '?')"; \
    echo "hvigor version      : $(jq -r '.version' /opt/ohos-sdk/hvigor/hvigor/package.json 2>/dev/null || echo '?')"; \
    echo "flutter tag         : ${FLUTTER_OHOS_TAG}"; \
    echo "template compatSdk  : $(grep -rh compatibleSdkVersion /opt/flutter/packages/flutter_tools/templates/app/ohos.tmpl/build-profile.json5.tmpl 2>/dev/null | tr -d ' ' || echo '?')"; \
    echo "template modelVer   : $(grep -rh modelVersion /opt/flutter/packages/flutter_tools/templates/app/ohos.tmpl/oh-package.json5.tmpl 2>/dev/null | tr -d ' ' || echo '?')"

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
