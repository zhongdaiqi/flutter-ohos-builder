FROM ubuntu:22.04

LABEL maintainer="zhongdaiqi"
LABEL description="Flutter + OpenHarmony build environment"
LABEL org.opencontainers.image.source="https://github.com/zhongdaiqi/flutter-ohos-builder"

ENV DEBIAN_FRONTEND=noninteractive
ENV JAVA_HOME=/opt/jdk-17
ENV NODE_HOME=/opt/node
ENV FLUTTER_HOME=/opt/flutter
ENV OHOS_SDK_ROOT=/opt/ohos-sdk
ENV DEVECO_SDK_HOME=/opt/ohos-sdk/command-line-tools/sdk
ENV HOS_SDK_HOME=/opt/ohos-sdk/command-line-tools/sdk
ENV OHOS_NDK_HOME=/opt/ohos-sdk/command-line-tools/sdk/default/openharmony
ENV PATH=/opt/ohos-sdk/command-line-tools/bin:/opt/ohos-sdk/command-line-tools/tool/node/bin:$JAVA_HOME/bin:$NODE_HOME/bin:$FLUTTER_HOME/bin:$PATH

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

# HarmonyOS Command Line Tools (SDK embedded)
# Source: ErBWs/ohos-sdk GitHub Releases — community mirror of official Huawei CLI tools
# NOTE: SDK must match the flutter_ohos tag's era — 3.22.4-ohos-1.1.5 targets API 12 (5.0.x).
# Newer SDK (6.x) breaks ArkTS compile (autoFillManager API shape changed).
ARG OHOS_SDK_VERSION=5.0.13.200
RUN mkdir -p /opt/ohos-sdk && cd /opt/ohos-sdk && \
    curl -fsSL -o sdk.aa \
      "https://github.com/ErBWs/ohos-sdk/releases/download/${OHOS_SDK_VERSION}/ohos-sdk-linux-amd64.tar.gz.aa" && \
    curl -fsSL -o sdk.ab \
      "https://github.com/ErBWs/ohos-sdk/releases/download/${OHOS_SDK_VERSION}/ohos-sdk-linux-amd64.tar.gz.ab" && \
    cat sdk.aa sdk.ab | tar -xzf - && \
    rm sdk.aa sdk.ab && \
    ls -la /opt/ohos-sdk/command-line-tools/bin/ && \
    hvigorw -v && ohpm -v

# Flutter OHOS fork (zhongdaiqi/flutter_flutter, synced from gitcode CPF-Flutter/flutter_flutter)
# NOTE: must clone a TAG (not branch) — flutter tool detects its version via git describe,
# a depth-1 branch clone has no tags and reports "0.0.0-unknown", breaking pub version solving.
ARG FLUTTER_OHOS_TAG=3.22.4-ohos-1.1.5
RUN git clone --depth 1 -b ${FLUTTER_OHOS_TAG} \
    https://github.com/zhongdaiqi/flutter_flutter.git /opt/flutter

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
