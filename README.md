# Tools version

- Meson 1.11.1
- ninja 1.13.1

# Build

```sh
$ docker build -t ghcr.io/higma-container/meson-ninja:v0.2 .
```

# Push

```sh
$ docker push ghcr.io/higma-container/meson-ninja:v0.2
```

# Multi Architecture

```sh
$ docker build --platform linux/amd64,linux/arm64 -t ghcr.io/higma-container/meson-ninja:v0.2 --push .
```
