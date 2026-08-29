# Overview

mesonとninjaがインストールされた環境のdockerイメージ

手動でビルドすることもciでビルドすることもできる

## Tools version

- Meson 1.11.1
- ninja 1.13.2

## 手動Build

```sh
$ docker build -t ghcr.io/higma-container/meson-ninja:v0.3 .
```

## Push

```sh
$ docker push ghcr.io/higma-container/meson-ninja:v0.3
```

## Multi Architecture

```sh
$ docker build --platform linux/amd64,linux/arm64 -t ghcr.io/higma-container/meson-ninja:v0.3 --push .
```

## Ciを使ったビルド

```sh
git add .
git commit -m "Update Docker image"
git push

git tag v0.3
git push origin v0.3
```
