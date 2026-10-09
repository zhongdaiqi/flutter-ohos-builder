FROM ubuntu:22.04

LABEL maintainer="zhongdaiqi"
LABEL description="Flutter + HarmonyOS build environment (OpenHarmony SDK embedded)"
LABEL org.opencontainers.image.source="https://github.com/zhongdaiqi/flutter-ohos-builder"

ENV DEBIAN_FRONTEND=noninteractive
ENV JAVA_HOME=/opt/jdk-17
ENV NODE_HOME=/opt/node
ENV FLUTTER_HOME=/opt/flutter

# HarmonyOS Command Line Tools root.
# The upstream tarball unpacks into a single top-level "command-line-tools/" directory;
# we strip that level so the CLI tools contents land directly in /opt/ohos-sdk.
# This makes hvigor live at /opt/ohos-sdk/hvigor (the path hvigorw/ohpm expect).
ENV OHOS_SDK_ROOT=/opt/ohos-sdk
ENV OHOS_SDK_HOME=/opt/ohos-sdk/sdk
ENV HOS_SDK_HOME=/opt/ohos-sdk/sdk
ENV DEVECO_SDK_HOME=/opt/ohos-sdk/sdk
ENV OHOS_NDK_HOME=/opt/ohos-sdk/sdk/default/openharmony
ENV PATH=/opt/ohos-sdk/bin:/opt/ohos-sdk/tool/node/bin:$JAVA_HOME/bin:$NODE_HOME/bin:$FLUTTER_HOME/bin:$PATH

# System dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    git curl unzip xz-utils ca-certificates jq file \
    libgl1-mesa-dev libxkbcommon-x11-0 libpulse0 \
    && rm -rf /var/lib/apt/lists/*

# JDK 17 (Adoptium Temurin - always latest GA, redirects to GitHub CDN)
RUN curl -fsSL "https://api.adoptium.net/v3/binary/latest/17/ga/linux/x64/jdk/hotspot/normal/eclipse" \
    | tar xz -C /opt && mv /opt/jdk-17* /opt/jdk-17

# Node.js 18 (Flutter tools need it; SDK also bundles its own)
RUN curl -fsSL https://nodejs.org/dist/v18.20.1/node-v18.20.1-linux-x64.tar.xz \
    | tar xJ -C /opt && mv /opt/node-v18.20.1-linux-x64 /opt/node

# HarmonyOS Command Line Tools (SDK embedded).
# Source: ErBWs/ohos-sdk GitHub Releases - community mirror of Huawei's CLI tools.
# 5.0.13.200 == "Command Line Tools for HarmonyOS 5.0.5 Release", which matches the
# API 12 target of the flutter_flutter 3.22.x-ohos line: its generated project template
# pins compatibleSdkVersion to "5.0.0(12)" with runtimeOS "HarmonyOS".
# The newer 6.x / 26.x lines belong to the API 20+ generation and are not compatible
# with the 3.22 branch's hvigor expectations.
ARG OHOS_SDK_VERSION=5.0.13.200
RUN mkdir -p /opt/ohos-sdk && cd /opt/ohos-sdk && \
    curl -fsSL -o sdk.aa \
      "https://github.com/ErBWs/ohos-sdk/releases/download/${OHOS_SDK_VERSION}/ohos-sdk-linux-amd64.tar.gz.aa" && \
    curl -fsSL -o sdk.ab \
      "https://github.com/ErBWs/ohos-sdk/releases/download/${OHOS_SDK_VERSION}/ohos-sdk-linux-amd64.tar.gz.ab" && \
    cat sdk.aa sdk.ab | tar -xzf - --strip-components=1 -C /opt/ohos-sdk && \
    rm -f sdk.aa sdk.ab

# --- diagnostics: dump the real layout into the build log (never fails; if this
# --- step itself failed it would hide the real cause, so every probe ends with `|| true`)
RUN echo "=== ls -la /opt/ohos-sdk ===";  ls -la /opt/ohos-sdk || true; \
    echo "=== dirs up to depth 2 ===";    find /opt/ohos-sdk -maxdepth 2 -type d 2>/dev/null | sort || true; \
    echo "=== ls -la /opt/ohos-sdk/sdk ===";    ls -la /opt/ohos-sdk/sdk || true; \
    echo "=== ls -la /opt/ohos-sdk/bin ===";    ls -la /opt/ohos-sdk/bin || true; \
    echo "=== ls -la /opt/ohos-sdk/hvigor ==="; ls -la /opt/ohos-sdk/hvigor || true; \
    echo "=== command -v hvigorw ===";    command -v hvigorw || true; \
    echo "=== command -v ohpm ===";       command -v ohpm || true; \
    true

# --- hard assertions: if the layout is wrong the build fails HERE, so the CI
# --- success/failure signal alone is enough to tell us whether the fix worked.
RUN test -f /opt/ohos-sdk/hvigor/hvigor-config.json5 \
    && echo "ASSERT OK: /opt/ohos-sdk/hvigor/hvigor-config.json5 exists"

RUN test -d /opt/ohos-sdk/sdk && test -n "$(ls -A /opt/ohos-sdk/sdk)" \
    && echo "ASSERT OK: /opt/ohos-sdk/sdk exists and is non-empty"

# Flutter OHOS fork (zhongdaiqi/flutter_flutter, synced from gitcode CPF-Flutter/flutter_flutter)
# NOTE: must clone a TAG (not branch) - the flutter tool detects its version via git describe,
# a depth-1 branch clone has no tags and reports "0.0.0-unknown", breaking pub version solving.
ARG FLUTTER_OHOS_TAG=3.22.4-ohos-1.1.5
RUN git clone --depth 1 -b ${FLUTTER_OHOS_TAG} \
    https://github.com/zhongdaiqi/flutter_flutter.git /opt/flutter

# --- tool usability (this is where the previous run died) ---
RUN hvigorw -v && ohpm -v

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
