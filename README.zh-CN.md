# flutter-ohos-builder

[中文](./README.zh-CN.md) | [English](./README.md)

> GitHub Action，用于将 Flutter 应用构建为 HarmonyOS `.hap` / `.app` 包。
> 也可作为 Docker 镜像用于本地或自托管 CI。

[![Self-test](https://github.com/zhongdaiqi/flutter-ohos-builder/actions/workflows/selftest.yml/badge.svg)](https://github.com/zhongdaiqi/flutter-ohos-builder/actions/workflows/selftest.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

本项目将 HarmonyOS 的命令行工具和 SDK 直接打进镜像中，因此构建时不需要在运行期下载大体积工具链。

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

Flutter OHOS 分支和 HarmonyOS SDK 是强绑定关系；混用不兼容版本时，`hvigor` 往往会在深层失败。

| 组件 | 版本 |
|---|---|
| Flutter OHOS fork | `3.41.10-ohos-1.0.1` |
| Command Line Tools | `26.0.0 Release` |
| SDK | `26.0.0` |
| hvigor | `6.26.8` |
| JDK | `17` |
| Node | `18.20.1` |

关键规则：应用编译必须使用 `compileSdkVersion=26`，而运行时兼容性可以保留为 `5.0.5(17)`。

## 输入参数

| 输入 | 说明 | 默认值 |
|---|---|---|
| `flutter-version` | Flutter OHOS 分支版本 | `3.41.10-ohos-1.0.1` |
| `ohos-api` | 镜像中内置的 HarmonyOS API 级别 | `26` |
| `build-mode` | `debug` 或 `release` | `release` |
| `build-target` | `hap` 或 `app` | `app` |
| `project-path` | Flutter 项目根目录 | `.` |
| `bundle-name` | `ohos/AppScope/app.json5` 中的 `bundleName` | 空 |
| `app-name` | 应用显示名称 | 空 |
| `sign-enabled` | 是否填充 `signingConfigs` | `false` |
| `sign-alg` | 签名算法 | `SHA256withECDSA` |
| `sign-key-alias` | `.p12` 的 key alias | 空 |
| `sign-key-password` | alias 密码 | 空 |
| `sign-store-password` | keystore 密码 | 空 |
| `sign-cert-base64` | `.cer` 文件 Base64 | 空 |
| `sign-profile-base64` | `.p7b` 配置文件 Base64 | 空 |
| `sign-store-file-base64` | `.p12` keystore Base64 | 空 |

## 工作原理

1. 使用支持 `ohos` 平台的 Flutter OHOS 分支。
2. 如需，先执行 `flutter create --platforms=ohos`。
3. 执行 `flutter pub get`。
4. 向 `ohos/build-profile.json5` 注入 `compileSdkVersion`。
5. 执行 `flutter build hap|app --<mode>`，并返回产物路径。

## 发布签名

`flutter create` 生成的 `ohos/build-profile.json5` 中，`signingConfigs` 往往为空，而应用还声明了 `"signingConfig": "default"`，因此 `release` 构建必须先补齐签名配置。

本 Action 支持接收 Base64 编码的签名文件，并在容器内写到 `/tmp` 后再生成 `build-profile.json5`。

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

如果 `CompileArkTS` 报缺失 ArkTS 符号，通常是 SDK 版本不匹配。请使用 `26.0.0` 工具链，并保持 `compileSdkVersion` 为 `26.0.0`。

## 免责声明

本项目是一个独立的社区开源工具，用于借助 Flutter 构建 HarmonyOS 应用，
不隶属于华为技术有限公司或 OpenAtom Foundation。

## License

MIT
