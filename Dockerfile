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
ENV PATH=/opt/ohos-sdk/bin:/opt/ohos-sdk/tool/node/bin:$JAVA_HOME/bin:$NODE_HOME/bin:$FLUTTER_HOME/bin:$PATH

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
# HarmonyOS Command Line Tools (SDK embedded at build time - no download at run time)
#
# Source : zhongdaiqi/command-line-tools-for-hmos (GitHub Releases, mirrors Huawei's
#          Command Line Tools for HarmonyOS)
# Release: clt-5.1.0.849  ==  HarmonyOS 5.1.0  (apiVersion 18, SDK 5.1.0.125, hvigor 5.18.6)
#
# Chosen because it is the generation the Flutter fork actually targets: the project
# template shipped by flutter_flutter 3.41.10-ohos-1.0.1 pins
# compatibleSdkVersion "5.1.0(18)" and modelVersion "5.1.0", so the only SDK hvigor
# will accept is apiVersion 18. The newer apis (6.1.1.418 -> api 20, 26.0.0.851 ->
# api 26) cannot satisfy it.
#
# The release asset is a ~2.05 GB ZIP that GitHub splits into two <=2 GiB parts
# ("commandline-tools-linux-x64-5.1.0.849.part_aa" + ".part_ab"). The split is a
# plain byte cut of one archive - the ZIP64 central directory sits at absolute
# offset 2136564979, past the end of part_aa (1610612736) - so concatenating the
# parts reconstructs the archive exactly.
#
# Uncompressed payload is ~6 GB, so the split parts are deleted the moment `unzip`
# is done, before the tree is moved into place.
# ---------------------------------------------------------------------------
ARG CLT_TAG=clt-5.1.0.849
ARG CLT_ASSET=commandline-tools-linux-x64-5.1.0.849
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
# clt-5.1.0.849 before this Dockerfile was written, so a failure here means the
# upstream package changed shape - not that the paths were guessed wrong.
RUN test -x /opt/ohos-sdk/bin/hvigorw && test -x /opt/ohos-sdk/bin/ohpm \
    && echo "ASSERT OK: bin/hvigorw and bin/ohpm are present and executable"

# Regression guard for the bug that broke clt-26.0.0.851: `mv src /opt/ohos-sdk`
# where /opt/ohos-sdk already existed put the tree one level too deep.
RUN test ! -e /opt/ohos-sdk/command-line-tools \
    && echo "ASSERT OK: no nested command-line-tools/ level under /opt/ohos-sdk"

RUN test -f /opt/ohos-sdk/sdk/default/sdk-pkg.json \
    && echo "ASSERT OK: sdk/default/sdk-pkg.json (apiVersion) exists"

RUN test -f /opt/ohos-sdk/hvigor/hvigor/package.json \
    && test -f /opt/ohos-sdk/hvigor/bin/hvigorw.js \
    && echo "ASSERT OK: hvigor runtime is present"

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
