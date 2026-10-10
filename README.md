# flutter-ohos-builder

[中文](./README.zh-CN.md) | [English](./README.md)

> GitHub Action that builds Flutter apps into HarmonyOS `.hap` / `.app` packages.
> Also works as a Docker image for local or self-hosted CI.

[![Self-test](https://github.com/zhongdaiqi/flutter-ohos-builder/actions/workflows/selftest.yml/badge.svg)](https://github.com/zhongdaiqi/flutter-ohos-builder/actions/workflows/selftest.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

This project bundles the HarmonyOS command line tools and SDK directly into the image, so builds do not download large toolchains at runtime.

## Quick start

### GitHub Action

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

### Local Docker

```bash
docker pull ghcr.io/zhongdaiqi/flutter-ohos-builder:latest

docker run --rm -v "$PWD":/workspace \
  ghcr.io/zhongdaiqi/flutter-ohos-builder:latest \
  --build-mode release --build-target app
```

## Version pairing

The Flutter OHOS fork and HarmonyOS SDK are version-coupled; mixing incompatible versions fails deep in `hvigor`.

| Component | Version |
|---|---|
| Flutter OHOS fork | `3.41.10-ohos-1.0.1` |
| Command Line Tools | `26.0.0 Release` |
| SDK | `26.0.0` |
| hvigor | `6.26.8` |
| JDK | `17` |
| Node | `18.20.1` |

Key rule: app compilation must use `compileSdkVersion=26`, while runtime compatibility can stay at `5.0.5(17)`.

## Inputs

| Input | Description | Default |
|---|---|---|
| `flutter-version` | Flutter OHOS fork tag | `3.41.10-ohos-1.0.1` |
| `ohos-api` | HarmonyOS API level baked into the image | `26` |
| `build-mode` | `debug` or `release` | `release` |
| `build-target` | `hap` or `app` | `app` |
| `project-path` | Flutter project root | `.` |
| `bundle-name` | `bundleName` in `ohos/AppScope/app.json5` | empty |
| `app-name` | App display name | empty |
| `ohos-sign-enabled` | Whether to fill `signingConfigs` | `false` |
| `ohos-sign-alg` | Signing algorithm | `SHA256withECDSA` |
| `ohos-sign-key-alias` | Key alias in the `.p12` keystore | empty |
| `ohos-sign-key-password` | Alias password | empty |
| `ohos-sign-store-password` | Keystore password | empty |
| `ohos-sign-cert-base64` | `.cer` file in base64 | empty |
| `ohos-sign-profile-base64` | `.p7b` profile in base64 | empty |
| `ohos-sign-store-file-base64` | `.p12` keystore in base64 | empty |

> Note: action input names above were renamed in the documentation to use the `ohos-` prefix for consistency; the secrets you provide to GitHub should use the `OHOS_` prefix (e.g. `OHOS_SIGN_ALG`). In workflow steps, map secrets to inputs like in the example below.

## How it works

1. Uses the Flutter OHOS fork that adds the `ohos` platform.
2. Runs `flutter create --platforms=ohos` if needed.
3. Runs `flutter pub get`.
4. Injects `compileSdkVersion` into `ohos/build-profile.json5`.
5. Runs `flutter build hap|app --<mode>` and reports the artifact path.

## Release signing

`flutter create` often leaves `signingConfigs` empty while the app still declares `"signingConfig": "default"`, so a `release` build will fail unless the signing config is filled.

The action accepts base64-encoded signing files and writes them to `/tmp` inside the container before generating `build-profile.json5`.

```yaml
- uses: zhongdaiqi/flutter-ohos-builder@main
  with:
    flutter-version: '3.41.10-ohos-1.0.1'
    ohos-api: '26'
    bundle-name: 'com.zhongdaiqi.app'
    app-name: 'flutter-ohos-app-template'
    build-mode: 'release'
    build-target: 'app'
    ohos-sign-enabled: 'true'
    ohos-sign-alg: ${{ secrets.OHOS_SIGN_ALG }}
    ohos-sign-key-alias: ${{ secrets.OHOS_SIGN_KEY_ALIAS }}
    ohos-sign-key-password: ${{ secrets.OHOS_SIGN_KEY_PASSWORD }}
    ohos-sign-store-password: ${{ secrets.OHOS_SIGN_STORE_PASSWORD }}
    ohos-sign-cert-base64: ${{ secrets.OHOS_SIGN_CERT_BASE64 }}
    ohos-sign-profile-base64: ${{ secrets.OHOS_SIGN_PROFILE_BASE64 }}
    ohos-sign-store-file-base64: ${{ secrets.OHOS_SIGN_STORE_FILE_BASE64 }}
```

## Troubleshooting

If `CompileArkTS` fails with missing ArkTS symbols, the usual cause is a mismatched SDK version. Use the `26.0.0` toolchain and keep `compileSdkVersion` at `26.0.0`.

## Disclaimer

This project is an independent community tool for building HarmonyOS applications with Flutter. It is not affiliated with Huawei Technologies Co., Ltd. or the OpenAtom Foundation.

## License

MIT
