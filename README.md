# Meson + Ninja Docker Image

Meson と Ninja がインストールされた Debian ベースの Docker イメージです。

Meson / Ninja を利用する CI やビルド環境などで使用できます。

## Tools Version

* Meson 1.12.0
* Ninja 1.13.2

## Supported Platforms

以下のプラットフォームに対応しています。

* `linux/amd64`
* `linux/arm64`

Docker が実行環境に応じて適切なイメージを自動的に選択します。

## Usage

### Pull

最新バージョンを取得する場合：

```sh
docker pull ghcr.io/higma-container/meson-ninja:latest
```

バージョンを指定する場合：

```sh
docker pull ghcr.io/higma-container/meson-ninja:v0.8
```

### Check Versions

CMake：

```sh
docker run --rm \
  ghcr.io/higma-container/meson-ninja:latest \
  meson --version
```

Ninja：

```sh
docker run --rm \
  ghcr.io/higma-container/meson-ninja:latest \
  ninja --version
```

## CI / Release

GitHub Actions を使用して Docker イメージをビルドしています。

`main` ブランチへの push および Pull Request では、以下のテストを実行します。

* `linux/amd64` のビルド
* `linux/arm64` のビルド
* Meson の起動確認
* Ninja の起動確認

GitHub Release を発行すると、`linux/amd64` と `linux/arm64` のイメージをビルドし、GHCRへpushします。

リリース時には Multi-platform manifest が作成されるため、利用者はアーキテクチャを意識せずにイメージを取得できます。

例えば `v0.8` をリリースした場合：

```sh
docker pull ghcr.io/higma-container/meson-ninja:v0.8
```

または：

```sh
docker pull ghcr.io/higma-container/meson-ninja:latest
```

## Repository

* GitHub: `higma-container/meson-ninja-docker-image`
* Container Registry: `ghcr.io/higma-container/meson-ninja`