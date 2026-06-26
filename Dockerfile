# ==========================================
# 1. meson builder
# ==========================================
FROM debian:trixie-slim AS mesonn-builder

ARG MESON_VERSION=1.11.1

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        git \
        python3 \
        python3-pip \
        ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN git clone --depth=1 --branch ${MESON_VERSION} https://github.com/mesonbuild/meson.git \
    && python3 -m pip install --no-cache-dir --prefix=/usr/local/meson-dist ./meson \
    && rm -rf meson

# ==========================================
# 2. Ninja Builder
# ==========================================
FROM debian:trixie-slim AS ninja-builder

ARG NINJA_VERSION=1.13.1

RUN apt-get update \
    && apt-get install -y --no-install-recommends curl cmake g++ make python3 ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN curl -OL https://github.com/ninja-build/ninja/archive/refs/tags/v${NINJA_VERSION}.tar.gz \
    && tar xf v${NINJA_VERSION}.tar.gz \
    && cd ninja-${NINJA_VERSION} \
    && cmake -B build -DCMAKE_INSTALL_PREFIX=/usr/local/ninja-dist \
    && cmake --build build -j$(nproc) \
    && cmake --install ./build \
    && cd .. \
    && rm -rf ninja-${NINJA_VERSION} v${NINJA_VERSION}.tar.gz

# ==========================================
# 3. runner
# ==========================================
FROM debian:trixie-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
        # for meson
        python3 \
    && rm -rf /var/lib/apt/lists/*

COPY --from=mesonn-builder /usr/local/meson-dist/ /usr/
COPY --from=ninja-builder /usr/local/ninja-dist/ /usr/local/
