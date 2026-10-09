# flutter-ohos-builder

> GitHub Action that builds Flutter apps into HarmonyOS `.hap` / `.app` packages.
> Also usable as a plain Docker image for local or self-hosted CI.

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
| `build-target` | `hap` or `app` | `app` |
| `project-path` | Path to the Flutter project root | `.` |

## Outputs

| Output | Description |
|---|---|
| `artifact-path` | Path to the built `.hap` / `.app` |

## How it works

1. Uses the Flutter OHOS fork, which adds the `ohos` platform plus `flutter build hap` / `flutter build app`.
2. Runs `flutter create --platforms=ohos` if the checked-out project has no `ohos/` directory yet.
3. Runs `flutter pub get`.
4. Injects `compileSdkVersion` into `ohos/build-profile.json5` to match the embedded SDK.
5. Runs `flutter build hap|app --<mode>` and reports the artifact path.

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
