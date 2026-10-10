# flutter-ohos-builder

[中文](./README.zh-CN.md) | [English](./README.md)

> GitHub Action that builds Flutter apps into HarmonyOS `.hap` / `.app` packages.
> Also usable as a plain Docker image for local or self-hosted CI.
>
> Supports Android APK builds as well, with signing disabled by default and can be turned on via `android-sign-enabled: 'true'`.

[![Self-test](https://github.com/zhongdaiqi/flutter-ohos-builder/actions/workflows/selftest.yml/badge.svg)](https://github.com/zhongdaiqi/flutter-ohos-builder/actions/workflows/selftest.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

The HarmonyOS **Command Line Tools + SDK are baked into the image**, so a build never
downloads gigabytes at run time — clone your project, run the action, get a signed-ready
artifact.

## Version pairing (read this first)

The Flutter OHOS fork and the HarmonyOS SDK are **not** independently versionable. Each
Flutter fork release pins its own mandatory toolchain, and mixing them fails deep inside
`hvigor` with errors that do not mention the real cause.

This image currently ships this combination:

| Component | Version | Source |
|---|---|---|
| Flutter OHOS fork | `3.41.10-ohos-1.0.1` | [zhongdaiqi/flutter_flutter](https://github.com/zhongdaiqi/flutter_flutter) |
| Command Line Tools | **26.0.0 Release** (`clt-26.0.0.851`) | [zhongdaiqi/command-line-tools-for-hmos](https://github.com/zhongdaiqi/command-line-tools-for-hmos) |
| SDK | apiVersion **26** / platformVersion 26.0.0 | included in the CLT above |
| hvigor | 6.26.8 | included in the CLT above |
| JDK | 17 (Temurin) | Adoptium |
| Node | 18.20.1 | nodejs.org |
| Android SDK | cmdline-tools + platform-tools + platforms 34/35/36 + build-tools 34.0.0/35.0.0/36.0.0 (baked in; entrypoint auto-installs any other compileSdk at run time) | dl.google.com |

Which comes straight from the upstream ReleaseNote bundled with the fork
(`release-notes/Flutter 3.41.9-ohos 1.0.1 ReleaseNote.md`, i.e. tag `3.41.10-ohos-1.0.1`):

| Requirement | Value | Where it goes |
|---|---|---|
| Command Line Tools | 26.0.0 Release | this image |
| SDK for building the engine | 26.0.0 | this image |
| SDK for building the app **(compile)** | **26.0.0** | `ohos/build-profile.json5` → `compileSdkVersion` |
| SDK for running the app (floor) | 5.0.5(17) | `ohos/build-profile.json5` → `compatibleSdkVersion` |

> Note the asymmetry that trips people up: the app must be **compiled** against SDK 26
> while only needing to **run** on 5.0.5(17). `flutter create` emits only
> `compatibleSdkVersion`, so this action injects `compileSdkVersion` for you — read
> from the embedded SDK, never hardcoded.

## Quick Start

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

### Android APK build (default unsigned)

```yaml
steps:
  - uses: actions/checkout@v4
  - name: Build unsigned Android APK
    uses: zhongdaiqi/flutter-ohos-builder@v1
    with:
      flutter-version: '3.41.10-ohos-1.0.1'
      build-target: 'android'
      build-mode: 'release'
      android-sign-enabled: 'false'
```

### Android APK build with signing

```yaml
steps:
  - uses: actions/checkout@v4
  - name: Build signed Android APK
    uses: zhongdaiqi/flutter-ohos-builder@v1
    with:
      flutter-version: '3.41.10-ohos-1.0.1'
      build-target: 'android'
      build-mode: 'release'
      android-sign-enabled: 'true'
      android-sign-key-alias: ${{ secrets.ANDROID_SIGN_KEY_ALIAS }}
      android-sign-key-password: ${{ secrets.ANDROID_SIGN_KEY_PASSWORD }}
      android-sign-store-base64: ${{ secrets.ANDROID_STORE_BASE64 }}
      android-sign-store-password: ${{ secrets.ANDROID_STORE_PASSWORD }}
```

### Local Docker

```bash
docker pull ghcr.io/zhongdaiqi/flutter-ohos-builder:latest

docker run --rm -v "$PWD":/workspace \
  ghcr.io/zhongdaiqi/flutter-ohos-builder:latest \
  --build-mode release --build-target app
```

## Inputs

| Input | Description | Default |
|---|---|---|
| `flutter-version` | Flutter OHOS fork version (a tag of `zhongdaiqi/flutter_flutter`) | `3.41.10-ohos-1.0.1` |
| `ohos-api` | HarmonyOS API level baked into the image | `26` |
| `build-mode` | `debug` or `release` | `release` |
| `build-target` | `hap`, `app`, or `android` | `app` |
| `project-path` | Path to the Flutter project root | `.` |
| `bundle-name` | `bundleName` written into `ohos/AppScope/app.json5` | *(empty = keep whatever `flutter create` generated)* |
| `app-name` | Display name written into `ohos/AppScope/resources/base/element/string.json` | *(empty)* |
| `ohos-sign-enabled` | `true` to fill `signingConfigs` in `build-profile.json5`. Required for `release` on HarmonyOS. | `false` |
| `ohos-sign-alg` | `signAlg` | `SHA256withECDSA` |
| `ohos-sign-key-alias` | `keyAlias` inside the `.p12` keystore | *(empty)* |
| `ohos-sign-key-password` | `keyPassword` — alias password inside the `.p12` | *(empty)* |
| `ohos-sign-store-password` | `storePassword` — keystore password of the `.p12` | *(empty)* |
| `ohos-sign-cert-base64` | AGC certificate `.cer`, base64-encoded, single line | *(empty)* |
| `ohos-sign-profile-base64` | Provisioning profile `.p7b`, base64-encoded, single line | *(empty)* |
| `ohos-sign-store-file-base64` | Keystore `.p12`, base64-encoded, single line | *(empty)* |
| `android-sign-enabled` | `true` to enable Android APK signing; default is unsigned build | `false` |
| `android-sign-key-alias` | Key alias inside the Android keystore | *(empty)* |
| `android-sign-key-password` | Key password for the Android keystore alias | *(empty)* |
| `android-sign-store-base64` | Android keystore `.jks` / `.keystore`, base64-encoded, single line | *(empty)* |
| `android-sign-store-password` | Keystore password | *(empty)* |

## Outputs

| Output | Description |
|---|---|
| `artifact-path` | Path to the built `.hap` / `.app` / `.apk` |

## How it works

1. Uses the Flutter OHOS fork, which adds the `ohos` platform plus `flutter build hap` / `flutter build app`.
2. Runs `flutter create --platforms=ohos` if the checked-out project has no `ohos/` directory yet.
3. Runs `flutter pub get`.
4. Injects `compileSdkVersion` into `ohos/build-profile.json5` to match the embedded SDK.
5. Runs Android `flutter build apk` when `build-target=android`.
6. Runs OHOS `flutter build hap|app --<mode>` for HarmonyOS targets and reports the artifact path.

## Android signing

Android builds are intentionally default-unsigned. If you need a signed release APK, enable signing explicitly:

```yaml
- uses: zhongdaiqi/flutter-ohos-builder@main
  with:
    flutter-version: '3.41.10-ohos-1.0.1'
    build-target: 'android'
    build-mode: 'release'
    android-sign-enabled: 'true'
    android-sign-key-alias: ${{ secrets.ANDROID_SIGN_KEY_ALIAS }}
    android-sign-key-password: ${{ secrets.ANDROID_SIGN_KEY_PASSWORD }}
    android-sign-store-base64: ${{ secrets.ANDROID_STORE_BASE64 }}
    android-sign-store-password: ${{ secrets.ANDROID_STORE_PASSWORD }}
```

The action writes an `android/key.properties` file internally, then deletes it after the build finishes so the repository workspace stays clean.

Recommended GitHub secrets:

| Secret | Value |
|---|---|
| `ANDROID_SIGN_KEY_ALIAS` | Android key alias |
| `ANDROID_SIGN_KEY_PASSWORD` | alias password |
| `ANDROID_STORE_BASE64` | Base64 of the `.jks`/`.keystore` file |
| `ANDROID_STORE_PASSWORD` | keystore password |

## Signing a release package (HarmonyOS)

`flutter create` emits `ohos/build-profile.json5` with an **empty** `signingConfigs`
array while the product still declares `"signingConfig": "default"`. So a `release`
build cannot produce a `.hap` / `.app` at all until that array is filled in.

Repository secrets hold text only, so the two certificates and the keystore travel as
base64. The builder decodes them to `/tmp` **inside the container** and writes the
absolute paths into `build-profile.json5`:

```
certpath     /tmp/ohos-sign/app.cer     <-- ohos-sign-cert-base64
profile      /tmp/ohos-sign/app.p7b     <-- ohos-sign-profile-base64
storeFile    /tmp/ohos-sign/app.p12     <-- ohos-sign-store-file-base64
```

Nothing is written into the mounted workspace and the container is discarded after the
step, so the material does not survive the job. Passwords are never echoed — the log
only reports their character count, and the dumped `build-profile.json5` has
`keyPassword` / `storePassword` replaced by `******`.

### 1. Encode the three files (PowerShell, Windows)

```powershell
$b64 = [Convert]::ToBase64String([IO.File]::ReadAllBytes("D:\ohsFlutter\cert\tusn.p12"))
[IO.File]::WriteAllText("D:\ohsFlutter\cert\tusn.p12.b64", $b64)
```

Repeat for the `.cer` and the `.p7b`. Each `.b64` file is **one single line** with no
line breaks and no trailing newline — copy it out with Notepad and trim any whitespace.

### 2. Add repository secrets

Settings → Secrets and variables → Actions → New repository secret:

| Secret | Value |
|---|---|
| `OHOS_SIGN_KEY_ALIAS` | keystore alias, e.g. `tuyun` |
| `OHOS_SIGN_KEY_PASSWORD` | alias password inside the `.p12` |
| `OHOS_SIGN_STORE_PASSWORD` | keystore password of the `.p12` |
| `OHOS_SIGN_ALG` | `SHA256withECDSA` |
| `OHOS_SIGN_CERT_BASE64` | contents of `<cert>.cer.b64` |
| `OHOS_SIGN_PROFILE_BASE64` | contents of `<profile>.p7b.b64` |
| `OHOS_SIGN_STORE_FILE_BASE64` | contents of `<keystore>.p12.b64` |

Each secret must stay well under GitHub's ~48 KB limit; these files normally encode to
2–10 KB. If a value ever exceeds it, split the base64 across several secrets and
concatenate them in the step that feeds the action.

### 3. Use them

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

`bundle-name` is not cosmetic: the provisioning profile is issued against one exact
bundle name, and hvigor refuses to sign if `ohos/AppScope/app.json5` disagrees.

## Troubleshooting

**`CompileArkTS` fails with errors about missing ArkTS symbols**, e.g.

```
Namespace 'autoFillManager' has no exported member 'AutoFillType'
```

You are compiling against a SDK older than the one the fork's prebuilt engine expects.
Those symbols (`AutoFillType`, `AutoFillTriggerType`, `FillRequest`, `FillFailureResult`,
`CompetitionStrategy`, `getGlobalWindowMode`, …) only exist **from apiVersion 26** — the
fork release that introduced them lists "支持密码保险箱功能" (password vault / autofill)
among its new features.

Fix: use a Command Line Tools 26.0.0-based image and make sure `compileSdkVersion` is
`26.0.0`. Do **not** "solve" it by pinning an older SDK to match the template's
`compatibleSdkVersion` — that number is a runtime floor, not the compile SDK.

## Disclaimer

This project is an independent community open-source tool for building HarmonyOS
applications with Flutter. It has no affiliation with or endorsement by Huawei
Technologies Co., Ltd. or the OpenAtom Foundation. "Flutter" is a trademark of Google
LLC; this project uses a community-adapted version. Command Line Tools are redistributed
from Huawei's official download and remain subject to their own licence terms.

## License

MIT
