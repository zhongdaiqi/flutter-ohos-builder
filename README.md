# flutter-ohos-builder

> GitHub Action to build Flutter apps into OpenHarmony `.hap`/`.app` packages.
> Also usable as a local Docker image for CI/CD pipelines.

[![Self-test](https://github.com/zhongdaiqi/flutter-ohos-builder/actions/workflows/selftest.yml/badge.svg)](https://github.com/zhongdaiqi/flutter-ohos-builder/actions/workflows/selftest.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Quick Start

### GitHub Actions

```yaml
steps:
  - uses: actions/checkout@v4
  - name: Build HarmonyOS App
    uses: zhongdaiqi/flutter-ohos-builder@v1
    with:
      flutter-version: '3.22.0-ohos'
      ohos-api: '12'
      build-mode: 'release'
      build-target: 'app'
```

### Local Docker

```bash
docker pull ghcr.io/zhongdaiqi/flutter-ohos-builder:latest

docker run --rm -v "$PWD":/workspace \
  ghcr.io/zhongdaiqi/flutter-ohos-builder:latest
```

## Inputs

| Input | Description | Default |
|-------|-------------|---------|
| `flutter-version` | Flutter OHOS fork version | `3.22.0-ohos` |
| `ohos-api` | OpenHarmony API level | `12` |
| `build-mode` | `debug` or `release` | `release` |
| `build-target` | `hap` or `app` | `app` |
| `project-path` | Path to Flutter project root | `.` |

## Outputs

| Output | Description |
|--------|-------------|
| `artifact-path` | Path to the built `.hap`/`.app` |

## How It Works

1. Uses the [openharmony-sig Flutter fork](https://gitcode.com/openharmony-sig/flutter_flutter) which adds `flutter build hap/app`
2. Runs `flutter pub get` to install dependencies
3. Runs `flutter build app --release` (or `--debug`)
4. Locates and reports the built artifact

## Disclaimer

This project is a community open-source tool for building OpenHarmony applications with Flutter.
It has no affiliation with or endorsement by Huawei Technologies Co., Ltd.
"OpenHarmony" is a project of the OpenAtom Foundation.
"Flutter" is a trademark of Google LLC; this project uses a community-adapted version.

## License

MIT
