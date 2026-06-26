# Tools version

- Meson 1.11.1
- ninja 1.13.1

# Build

```sh
docker run -it yoshiyasu1111/meson-ninja:v0.1 /bin/bash
```

# Push

```sh
$ docker push yoshiyasu1111/meson-ninja:v0.1  
```

# Multi Architecture

```sh
$ docker build --platform linux/amd64,linux/arm64 -t yoshiyasu1111/meson-ninja:v0.1 --push .
```
