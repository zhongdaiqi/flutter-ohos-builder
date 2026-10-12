# flutter-ohos-builder

[中文](./README.zh-CN.md) | [English](./README.md)

> Flutter HarmonyOS 打包构建工具
> GitHub Action + Docker 镜像，帮助你快速把 Flutter 应用构建成 HarmonyOS `.hap` / `.app`。

[![Self-test](https://github.com/zhongdaiqi/flutter-ohos-builder/actions/workflows/selftest.yml/badge.svg)](https://github.com/zhongdaiqi/flutter-ohos-builder/actions/workflows/selftest.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

如果你在做 Flutter + HarmonyOS 应用开发，最头疼的往往不是代码本身，而是环境和工具链不一致：

- Flutter OHOS 分支版本不匹配
- HarmonyOS SDK / Command Line Tools 版本不兼容
- `compileSdkVersion` 和 `compatibleSdkVersion` 混用
- 发布包签名配置缺失
- CI/CD 中无法稳定复现构建环境

`flutter-ohos-builder` 就是为了解决这些问题而设计的。

它把 Flutter OHOS 分支、HarmonyOS 命令行工具、SDK、JDK、Node 和 `hvigor` 统一打进镜像中，
让你可以用同一套环境在本地、GitHub Actions 或自托管 CI 中稳定构建 HarmonyOS 应用。

## 适合谁使用

- 需要把 Flutter 应用打包成 HarmonyOS `.hap` / `.app` 的开发者
- 想在 GitHub Actions 中实现持续构建的团队
- 希望构建环境可复现、版本稳定、部署简单的工程师
- 需要在本地或私有 CI 中快速做签名构建和验证的人

## 核心优势

- 一键式 GitHub Action
- 本地 Docker 可直接运行
- 内置完整 HarmonyOS 构建工具链
- 自动处理 `compileSdkVersion` 注入
- 支持发布签名所需的 Base64 证书资产
- 版本关系清晰，便于维护和排查

## 版本说明

当前默认使用的组合是：

| 组件 | 版本 |
|---|---|
| Flutter OHOS fork | `3.41.10-ohos-1.0.1` |
| Command Line Tools | `26.0.0 Release` |
| SDK | `26.0.0` |
| hvigor | `6.26.8` |
| JDK | `17` |
| Node | `18.20.1` |
| Android SDK | cmdline-tools + platform-tools + platforms `34/35/36` + build-tools `34.0.0/35.0.0/36.0.0`（已内置；entrypoint 会按 Flutter fork 实际 compileSdk 在运行时自动补齐缺失平台） |

最关键的一点是：

- 应用编译必须使用 `compileSdkVersion = 26`
- 运行时兼容可以保留 `compatibleSdkVersion = 5.0.5(17)`

这也是本项目自动注入编译 SDK 的原因。

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

> **`$PWD` 是什么？**
>
> `$PWD` 是 shell 自带的环境变量（全称 Print Working Directory），值就是**你当前所在的目录**。
> 所以 `-v "$PWD":/workspace` 的含义是：**把「当前目录」挂进容器的 `/workspace`** ——
> 容器读取的 Flutter 工程来自这里，构建产物（`ohos/build/outputs/...`）也写回这里。
>
> 因此执行前**必须先 `cd` 到你的 Flutter 项目根目录**：
>
> ```bash
> cd /path/to/your/flutter_ohos_project   # 就是有 pubspec.yaml 和 ohos/ 目录的那一层
> ```
>
> 否则挂进去的是别的目录，容器找不到工程，构建会直接失败。
>
> 不同命令行的等价写法：
>
> | 环境 | 挂载参数写法 |
> |---|---|
> | Linux / macOS / Git Bash / WSL | `-v "$PWD":/workspace` |
> | Windows PowerShell | `-v "${PWD}":/workspace` 或 `-v "$(Get-Location)":/workspace` |
> | Windows CMD | `-v "%CD%":/workspace` |
>
> 两个新手常见坑：
>
> 1. **Windows 需要先开文件共享**：Docker Desktop → Settings → Resources → File sharing，
>    勾选项目所在盘符，否则挂载会报 `filesharing has been cancelled` / 路径不存在。
> 2. **产物属主是 root**：镜像没有 `USER` 指令，容器以 root 运行，写回宿主的产物文件属主会是 root，
>    Linux / macOS 上用普通用户删改可能提示权限不足，需要 `sudo chown -R $USER .`。


## 使用方式

### 基础参数

| 参数 | 说明 | 默认值 |
|---|---|---|
| `flutter-version` | Flutter OHOS 分支版本 | `3.41.10-ohos-1.0.1` |
| `ohos-api` | HarmonyOS API 级别 | `26` |
| `build-mode` | 构建模式：`debug` / `release` | `release` |
| `build-target` | 构建目标：`hap` / `app` | `app` |
| `project-path` | Flutter 项目根目录 | `.` |

### 签名参数

| 参数 | 说明 |
|---|---|
| `bundle-name` | `ohos/AppScope/app.json5` 中的 `bundleName` |
| `app-name` | 应用显示名称 |
| `ohos-sign-enabled` | 是否写入签名配置 |
| `ohos-sign-alg` | 签名算法 |
| `ohos-sign-key-alias` | `.p12` key alias |
| `ohos-sign-key-password` | alias 密码 |
| `ohos-sign-store-password` | keystore 密码 |
| `ohos-sign-cert-base64` | `.cer` 证书 Base64 |
| `ohos-sign-profile-base64` | `.p7b` 配置文件 Base64 |
| `ohos-sign-store-file-base64` | `.p12` keystore Base64 |
| `ohos-sign-material-base64` | DevEco 签名材料 zip Base64 |

## 发布签名示例

```yaml
- uses: zhongdaiqi/flutter-ohos-builder@v1.4
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
    ohos-sign-material-base64: ${{ secrets.OHOS_SIGN_MATERIAL_BASE64 }}
```

## 为什么这个项目值得用

很多人一开始以为 HarmonyOS 构建只是一个命令行问题，
但真实情况是：工具链版本、编译目标、签名配置和工程结构都必须同步正确。

`flutter-ohos-builder` 让这些事标准化，减少“本地能跑、CI 不能跑”的问题，
帮助团队把 Android / Flutter / HarmonyOS 的构建流程变成更稳定、可维护的自动化能力。

## 适用场景

- Flutter + HarmonyOS 项目持续构建
- 预发布包生成与验签
- 企业级 CI/CD 流水线接入
- 本地打包验证与调试
- 统一多台机器上的构建环境

## 免责声明

本项目是一个独立的社区开源工具，用于协助 Flutter 应用构建 HarmonyOS 包，
不隶属于华为技术有限公司或 OpenAtom Foundation。

## License

MIT
