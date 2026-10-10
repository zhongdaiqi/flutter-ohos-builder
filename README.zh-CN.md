# flutter-ohos-builder

[中文](./README.zh-CN.md) | [English](./README.md)

> GitHub Action，用于将 Flutter 应用构建为 HarmonyOS `.hap` / `.app` 包。
> 也可作为普通 Docker 镜像在本地或自托管 CI 中使用。

[![Self-test](https://github.com/zhongdaiqi/flutter-ohos-builder/actions/workflows/selftest.yml/badge.svg)](https://github.com/zhongdaiqi/flutter-ohos-builder/actions/workflows/selftest.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

HarmonyOS 的 **Command Line Tools + SDK 被直接 baked（内置）到镜像中**，因此构建时
不会在运行时下载大量数据包 —— 只需克隆你的项目，运行本 Action，即可得到一个
可直接签名的产物。

## 先说版本匹配（必须先看）

Flutter OHOS 分支和 HarmonyOS SDK **不能随意单独升级**。每个 Flutter 分支版本都会
绑定其所需的强制工具链；如果混用，会在 `hvigor` 深处失败，而且错误信息通常不会
直接指出真正原因。

当前镜像内置的组合如下：

| 组件 | 版本 | 来源 |
|---|---|---|
| Flutter OHOS fork | `3.41.10-ohos-1.0.1` | [zhongdaiqi/flutter_flutter](https://github.com/zhongdaiqi/flutter_flutter) |
| Command Line Tools | **26.0.0 Release** (`clt-26.0.0.851`) | [zhongdaiqi/command-line-tools-for-hmos](https://github.com/zhongdaiqi/command-line-tools-for-hmos) |
| SDK | apiVersion **26** / platformVersion 26.0.0 | included in the CLT above |
| hvigor | 6.26.8 | included in the CLT above |
| JDK | 17 (Temurin) | Adoptium |
| Node | 18.20.1 | nodejs.org |

这正是来自该分支内置的上游 Release Note：
(`release-notes/Flutter 3.41.9-ohos 1.0.1 ReleaseNote.md`，对应 tag `3.41.10-ohos-1.0.1`)

| 要求 | 值 | 放在哪里 |
|---|---|---|
| Command Line Tools | 26.0.0 Release | this image |
| 用于构建引擎的 SDK | 26.0.0 | this image |
| 用于构建应用 **（编译）** 的 SDK | **26.0.0** | `ohos/build-profile.json5` → `compileSdkVersion` |
| 用于运行应用（运行时/最低兼容）的 SDK | 5.0.5(17) | `ohos/build-profile.json5` → `compatibleSdkVersion` |

> 这里最容易踩坑的点在于：应用必须按 **SDK 26 编译**，而仅需在 **5.0.5(17)** 上运行。
> `flutter create` 只会生成 `compatibleSdkVersion`，所以本 Action 会自动为你补上
> `compileSdkVersion` —— 读取的是内置 SDK，而不是硬编码。

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

## Inputs

| 输入 | 说明 | 默认值 |
|---|---|---|
| `flutter-version` | Flutter OHOS 分支版本（`zhongdaiqi/flutter_flutter` 的 tag） | `3.41.10-ohos-1.0.1` |
| `ohos-api` | 镜像中写死的 HarmonyOS API 级别 | `26` |
| `build-mode` | `debug` 或 `release` | `release` |
| `build-target` | `hap` 或 `app` | `app` |
| `project-path` | Flutter 项目根目录路径 | `.` |
| `bundle-name` | 写入 `ohos/AppScope/app.json5` 的 `bundleName`。必须和 `.p7b` 配置文件签发时使用的包名一致。 | *(空 = 保持 `flutter create` 生成的值)* |
| `app-name` | 写入 `ohos/AppScope/resources/base/element/string.json` 的显示名称 | *(空)* |
| `sign-enabled` | `true` 时填充 `build-profile.json5` 中的 `signingConfigs`。`release` 构建时通常需要开启。 | `false` |
| `sign-alg` | `signAlg` | `SHA256withECDSA` |
| `sign-key-alias` | `.p12` keystore 中的 `keyAlias` | *(空)* |
| `sign-key-password` | `.p12` 中 alias 的密码，`keyPassword` | *(空)* |
| `sign-store-password` | `.p12` keystore 的密码，`storePassword` | *(空)* |
| `sign-cert-base64` | AGC 证书 `.cer` 的 base64 编码，单行 | *(空)* |
| `sign-profile-base64` | 证书配置文件 `.p7b` 的 base64 编码，单行 | *(空)* |
| `sign-store-file-base64` | Keystore `.p12` 的 base64 编码，单行 | *(空)* |

## Outputs

| 输出 | 说明 |
|---|---|
| `artifact-path` | 构建出的 `.hap` / `.app` 文件路径 |

## 工作原理

1. 使用 Flutter OHOS 分支，它新增了 `ohos` 平台，并支持 `flutter build hap` / `flutter build app`。
2. 如果被检查出的项目目录里还没有 `ohos/`，则先执行 `flutter create --platforms=ohos`。
3. 执行 `flutter pub get`。
4. 向 `ohos/build-profile.json5` 注入 `compileSdkVersion`，以匹配内置 SDK。
5. 执行 `flutter build hap|app --<mode>`，并返回产物路径。

## 签名发布包

`flutter create` 生成的 `ohos/build-profile.json5` 里，`signingConfigs` 往往是**空数组**，
同时产品仍声明 `"signingConfig": "default"`。因此如果是 `release` 构建，
在补齐签名配置前，`.hap` / `.app` 根本无法生成。

仓库 Secrets 只能保存文本，因此证书和 keystore 会以 base64 形式传递。
构建器会在容器内将它们解码到 `/tmp`，并将绝对路径写入 `build-profile.json5`：

```
certpath     /tmp/ohos-sign/app.cer     <-- sign-cert-base64
profile      /tmp/ohos-sign/app.p7b     <-- sign-profile-base64
storeFile    /tmp/ohos-sign/app.p12     <-- sign-store-file-base64
```

容器不会写入挂载的工作目录，而且在该步骤完成后该容器会被丢弃，所以这些材料不会
残留在工作区中。密码不会被回显到日志中 —— 日志只会记录字符长度，且输出的
`build-profile.json5` 会把 `keyPassword` / `storePassword` 替换成 `******`。

### 1. 对三个文件做 base64 编码（PowerShell，Windows）

```powershell
$b64 = [Convert]::ToBase64String([IO.File]::ReadAllBytes("D:\ohsFlutter\cert\tusn.p12"))
[IO.File]::WriteAllText("D:\ohsFlutter\cert\tusn.p12.b64", $b64)
```

对 `.cer` 和 `.p7b` 也重复同样操作。每个 `.b64` 文件都必须是**单行**，不能包含
换行符或末尾换行 —— 可用 Notepad 打开后复制，必要时去掉空白字符。

### 2. 添加仓库 Secrets

Settings → Secrets and variables → Actions → New repository secret：

| Secret | 值 |
|---|---|
| `OHOS_SIGN_KEY_ALIAS` | keystore 别名，例如 `tuyun` |
| `OHOS_SIGN_KEY_PASSWORD` | `.p12` 中 alias 的密码 |
| `OHOS_SIGN_STORE_PASSWORD` | `.p12` keystore 的密码 |
| `OHOS_SIGN_ALG` | `SHA256withECDSA` |
| `OHOS_SIGN_CERT_BASE64` | `<cert>.cer.b64` 的内容 |
| `OHOS_SIGN_PROFILE_BASE64` | `<profile>.p7b.b64` 的内容 |
| `OHOS_SIGN_STORE_FILE_BASE64` | `<keystore>.p12.b64` 的内容 |

这些 Secret 必须远小于 GitHub 的约 48 KB 限制；通常这些文件编码后只有 2–10 KB。
如果某个值超过限制，可以拆成多个 secret，然后在传给 Action 的步骤中拼接起来。

### 3. 在工作流中使用它们

```yaml
- uses: zhongdaiqi/flutter-ohos-builder@main
  with:
    flutter-version: '3.41.10-ohos-1.0.1'
    ohos-api: '26'
    bundle-name: 'com.zhongdaiqi.app'      # 必须与 .p7b 匹配
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

`bundle-name` 并非装饰项：签名配置文件对应的是精确的 bundle 名称；如果
`ohos/AppScope/app.json5` 里的值和 `.p7b` 不一致，`hvigor` 会直接拒绝签名。

### 哪些内容不应该放进 Secrets

| 项目 | 实际应放置的位置 |
|---|---|
| App 名称（`flutter-ohos-app-template`） | `app-name` 输入 → `AppScope/resources/base/element/string.json` |
| Bundle 名称（`com.zhongdaiqi.app`） | `bundle-name` 输入 → `AppScope/app.json5`。这是公开元数据，不是 secret。 |
| APP ID（`6917618631485252007`） | AppGallery Connect 自己的应用标识符。不参与签名；通常只在后续调用 AGC 发布 API 时才需要。应存储为仓库 **variable**，而不是 secret。 |

## 故障排查

**`CompileArkTS` 报错：缺少 ArkTS 符号**，例如：

```
Namespace 'autoFillManager' has no exported member 'AutoFillType'
```

这通常表示你编译时使用的 SDK 版本低于该分支预编译引擎所期望的版本。
这些��号（`AutoFillType`、`AutoFillTriggerType`、`FillRequest`、`FillFailureResult`、
`CompetitionStrategy`、`getGlobalWindowMode` 等）只有在 **apiVersion 26** 及以上才存在 ——
对应的分支发布说明中把它们列为了新功能（例如“支持密码保险箱功能”）。

修复方式：使用基于 Command Line Tools 26.0.0 的镜像，并确保 `compileSdkVersion`
是 `26.0.0`。不要通过把较旧 SDK 版本钉在模板的 `compatibleSdkVersion` 上来“绕过去”——
这个数字代表的是运行时最低支持版本，而不是编译 SDK。

## 免责声明

本项目是一个独立的社区开源工具，用于借助 Flutter 构建 HarmonyOS 应用，
与华为技术有限公司或 OpenAtom Foundation 没有隶属关系，也不受其背书。
“Flutter” 是 Google LLC 的商标；本项目使用的是社区适配版本。
命令行工具（Command Line Tools）来自华为官方下载，并受其各自许可协议约束。

## License

MIT
