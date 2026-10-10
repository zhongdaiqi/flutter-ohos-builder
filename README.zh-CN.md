# flutter-ohos-builder

[中文](./README.zh-CN.md) | [English](./README.md)

> GitHub Action + Docker 镜像，用于将 Flutter 应用构建为 HarmonyOS `.hap` / `.app` 包。

[![Self-test](https://github.com/zhongdaiqi/flutter-ohos-builder/actions/workflows/selftest.yml/badge.svg)](https://github.com/zhongdaiqi/flutter-ohos-builder/actions/workflows/selftest.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

`flutter-ohos-builder` 旨在消除 HarmonyOS 构建环境搭建的繁琐步骤。
它会把所需的 Flutter OHOS fork、HarmonyOS Command Line Tools、SDK、JDK、Node 与 `hvigor` 一并打进镜像中，因此无需在 CI 运行阶段再次下载大量工具链。

## 这个项目解决什么问题

并不是只运行 `flutter build` 就能完成 HarmonyOS 打包；它需要一个完整且严格匹配的链路：

- 对应版本的 Flutter OHOS fork
- 正确的 HarmonyOS SDK 和命令行工具
- 匹配的编译 SDK 版本
- 合法的发布签名��置

这个项目的目标，就是让这些内容稳定、可复现，并能在 GitHub Actions 与本地 Docker 中统一执行。

## 亮点

- 开箱即用的 GitHub Action
- 可用作普通 Docker 镜像，适合本地和自托管 CI
- 将工具链直接内置到镜像中，避免运行期下载
- 自动注入所需的 `compileSdkVersion`
- 支持 Base64 证书资产进行发布签名
- 明确暴露版本依赖，便于核验和维护

## 快速开始

### GitHub Actions

```yaml
steps:
  - uses: actions/checkout@v4
  - name: Build HarmonyOS app
    uses: zhongdaiqi/flutter-ohos-builder@v1
    with:
      flutter-version: '3.41.10-ohos-1.0.1'
      build-mode: 'release'
      build-target: 'app'
```

### 本地 Docker

```bash
docker pull ghcr.io/zhongdaiqi/flutter-ohos-builder:latest

docker run --rm -v "$PWD":/workspace \
  ghcr.io/zhongdaiqi/flutter-ohos-builder:latest \
  --build-mode release --build-target app
```

## 版本匹配

Flutter OHOS 分支与 HarmonyOS SDK 是强绑定关系；混用不兼容版本时，`hvigor` 往往会在深层失败，且错误信息经常会误导排查。

| 组件 | 版本 |
|---|---|
| Flutter OHOS fork | `3.41.10-ohos-1.0.1` |
| Command Line Tools | `26.0.0 Release` |
| SDK | `26.0.0` |
| hvigor | `6.26.8` |
| JDK | `17` |
| Node | `18.20.1` |

关键规则：

- 编译 SDK 必须为 `26.0.0`
- 运行时兼容版本可以保留在 `5.0.5(17)`

这也是为什么本 Action 会自动为 `ohos/build-profile.json5` 注入 `compileSdkVersion`。

## 输入参数

| 输入 | 说明 | 默认值 |
|---|---|---|
| `flutter-version` | Flutter OHOS fork 版本 | `3.41.10-ohos-1.0.1` |
| `ohos-api` | 镜像中写入的 HarmonyOS API 级别 | `26` |
| `build-mode` | `debug` 或 `release` | `release` |
| `build-target` | `hap` 或 `app` | `app` |
| `project-path` | Flutter 项目根目录 | `.` |
| `bundle-name` | `ohos/AppScope/app.json5` 中的 `bundleName` | 空 |
| `app-name` | 应用显示名称 | 空 |
| `sign-enabled` | 是否写入 `signingConfigs` | `false` |
| `sign-alg` | 签名算法 | `SHA256withECDSA` |
| `sign-key-alias` | `.p12` 中的 key alias | 空 |
| `sign-key-password` | alias 密码 | 空 |
| `sign-store-password` | keystore 密码 | 空 |
| `sign-cert-base64` | `.cer` 文件 Base64 | 空 |
| `sign-profile-base64` | `.p7b` 配置文件 Base64 | 空 |
| `sign-store-file-base64` | `.p12` keystore Base64 | 空 |

## 工作原理

1. 使用支持 `ohos` 平台的 Flutter OHOS 分支。
2. 如有需要，先执行 `flutter create --platforms=ohos`。
3. 执行 `flutter pub get`。
4. 向 `ohos/build-profile.json5` 注入 `compileSdkVersion`。
5. 执行 `flutter build hap|app --<mode>`，并返回产物路径。

## 发布签名

标准 `flutter create` 生成的 `ohos/build-profile.json5` 常常会出现 `signingConfigs` 为空，而应用又声明了 `"signingConfig": "default"` 的情况，因此 `release` 构建必须先补齐签名配置。

本 Action 支持接收 Base64 编码的签名文件，并在容器中写入 `/tmp`，随后再生成 `build-profile.json5`。

```yaml
- uses: zhongdaiqi/flutter-ohos-builder@main
  with:
    flutter-version: '3.41.10-ohos-1.0.1'
    ohos-api: '26'
    bundle-name: 'com.zhongdaiqi.app'
    app-name: 'flutter-ohos-app-template'
    build-mode: 'release'
    build-target: 'app'
    sign-enabled: 'true'
    sign-alg: ${{ secrets.OHOS_SIGN_ALG }}
    sign-key-alias: ${{ secrets.OHOS_SIGN_KEY_ALIAS }}
    sign-key-password: ${{ secrets.OHOS_SIGN_KEY_PASSWORD }}
    sign-store-password: ${{ secrets.OHOS_SIGN_STORE_PASSWORD }}
    sign-cert-base64: ${{ secrets.OHOS_SIGN_CERT_BASE64 }}
    sign-profile-base64: ${{ secrets.OHOS_SIGN_PROFILE_BASE64 }}
    sign-store-file-base64: ${{ secrets.OHOS_SIGN_STORE_FILE_BASE64 }}
```

## 故障排查

如果 `CompileArkTS` 报错提示缺失 ArkTS 符号，通常原因是 SDK 版本不匹配。

请使用 `26.0.0` 工具链，并保持 `compileSdkVersion` 为 `26.0.0`。
不要尝试把编译 SDK 降到 `compatibleSdkVersion` 的值来“绕过去”，因为后者表示运行时最低要求，而不是编译目标。

## 常见用途

- Flutter 应用的 HarmonyOS CI 构建
- 发布前的本地打包
- 不同开发者机器之间的统一构建环境
- 自托管 CI 或企业流水线集成

## 免责声明

本项目是一个独立的社区开源工具，用于借助 Flutter 构建 HarmonyOS 应用，
不隶属于华为技术有限公司或 OpenAtom Foundation。

## License

MIT
