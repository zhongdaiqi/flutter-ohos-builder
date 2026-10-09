FROM ubuntu:22.04

LABEL maintainer="zhongdaiqi"
LABEL description="Flutter + OpenHarmony build environment"
LABEL org.opencontainers.image.source="https://github.com/zhongdaiqi/flutter-ohos-builder"

ENV DEBIAN_FRONTEND=noninteractive
ENV JAVA_HOME=/opt/jdk-17
ENV NODE_HOME=/opt/node
ENV FLUTTER_HOME=/opt/flutter
ENV DEVECO_SDK_HOME=/opt/ohos-sdk
ENV HOS_SDK_HOME=/opt/ohos-sdk
ENV OHOS_NDK_HOME=/opt/ohos-sdk/default/openharmony
ENV PATH=$JAVA_HOME/bin:$NODE_HOME/bin:$FLUTTER_HOME/bin:$PATH

# System dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    git curl unzip xz-utils ca-certificates jq file \
    libgl1-mesa-dev libxkbcommon-x11-0 libpulse0 \
    && rm -rf /var/lib/apt/lists/*

# JDK 17
RUN curl -fsSL https://download.oracle.com/java/17/latest/jdk-17_linux-x64_bin.tar.gz \
    | tar xz -C /opt && mv /opt/jdk-17* /opt/jdk-17

# Node.js 18 (required by ohpm/hvigor)
RUN curl -fsSL https://nodejs.org/dist/v18.20.1/node-v18.20.1-linux-x64.tar.xz \
    | tar xJ -C /opt && mv /opt/node-v18.20.1-linux-x64 /opt/node

# Flutter OHOS fork (openharmony-sig)
ARG FLUTTER_OHOS_BRANCH=dev
RUN git clone --depth 1 -b ${FLUTTER_OHOS_BRANCH} \
    https://gitcode.com/openharmony-sig/flutter_flutter.git /opt/flutter

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
