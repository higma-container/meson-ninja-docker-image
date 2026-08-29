# Development

このドキュメントは、`meson-ninja-docker-image` の開発・リリース時に使用するメモです。

## Local Build

ローカルでDockerイメージをビルドする場合：

```sh
docker build -t meson-ninja:local .
```

ビルド後にCMakeを確認：

```sh
docker run --rm meson-ninja:local meson --version
```

Ninjaを確認：

```sh
docker run --rm meson-ninja:local ninja --version
```

## Multi-platform Build

ローカルから `linux/amd64` と `linux/arm64` のイメージをビルドする場合：

```sh
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  -t ghcr.io/higma-container/meson-ninja:v0.8 \
  --push .
```

## GitHub Actions

GitHub Actions のWorkflowは以下の2つに分かれています。

```text
.github/workflows/
├── test.yaml
└── release.yaml
```

### test.yaml

`main` ブランチへのpush、およびPull Requestで実行します。

```text
main / Pull Request
        │
        ├── amd64 build + test
        │
        └── arm64 build + test
```

GHCRへのpushは行いません。

各アーキテクチャのrunner上でイメージをビルドし、以下を確認します。

```sh
meson --version
ninja --version
which meson
which ninja
```

### release.yaml

GitHub Releaseが `published` されたときに実行します。

```text
GitHub Release
      │
      ├── amd64 build → GHCR
      │
      └── arm64 build → GHCR
                    │
                    ↓
              Multi-platform
                 manifest
                    │
              ┌─────┴─────┐
              ↓           ↓
            vX.Y         latest
```

例えば `v0.8` をリリースすると、

```text
ghcr.io/higma-container/meson-ninja:v0.8
ghcr.io/higma-container/meson-ninja:latest
```

が作成されます。

各アーキテクチャの中間イメージとして、

```text
v0.8-amd64
v0.8-arm64
```

も作成されます。

## Build Cache

`test.yaml` と `release.yaml` ではGitHub ActionsのBuildKit cacheを共有しています。

amd64：

```yaml
cache-from: type=gha,scope=meson-ninja-amd64
cache-to: type=gha,mode=max,scope=meson-ninja-amd64
```

arm64：

```yaml
cache-from: type=gha,scope=meson-ninja-arm64
cache-to: type=gha,mode=max,scope=meson-ninja-arm64
```

そのため、mainへのpushで作成されたビルドキャッシュをRelease時にも利用できます。

```text
main push
   │
   ↓
test.yaml
   │
   ├── amd64 ──→ meson-ninja-amd64 cache
   │
   └── arm64 ──→ meson-ninja-arm64 cache
                         │
                         ↓
                    release.yaml
```

Dockerfileの変更内容によってキャッシュの利用状況は変わります。

## GHCR Permissions

GitHub ActionsからGHCRへpushするため、Workflowでは以下の権限を使用します。

```yaml
permissions:
  contents: read
  packages: write
```

GHCRのPackage側でも、対象RepositoryからのActionsによるアクセスにWrite権限が必要です。

Package settingsのActions accessから、

```text
higma-container/meson-ninja-docker-image
```

にWrite権限を設定します。

GHCRへのpush時に以下のエラーが発生した場合：

```text
denied: permission_denied: read_package
```

Package側のActions accessを確認します。

## Docker Image Repository

GHCRのイメージ：

```text
ghcr.io/higma-container/meson-ninja
```

GitHub Repository：

```text
higma-container/meson-ninja-docker-image
```

DockerfileにはRepositoryとの関連付けのため、以下のLABELを設定しています。

```dockerfile
LABEL org.opencontainers.image.source="https://github.com/higma-container/meson-ninja-docker-image"
```

## Release

リリース時はGitHubでReleaseを作成します。

例えば：

```text
Tag: v0.8
```

Releaseを `published` にすると `release.yaml` が実行されます。

CIが失敗した場合は、Dockerfileなどを修正した上でWorkflowを再実行します。

ビルドに失敗しただけの場合は、成功するまで同じバージョンで再実行し、不要に次のバージョンへ上げないようにします。