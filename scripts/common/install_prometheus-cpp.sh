#!/bin/bash

set -ex

CIVETWEB_VERSION=1.16
PROMETHEUS-CPP_VERSION=4.13.1

command -v yum >/dev/null && {
    yum install -y libcurl-devel zlib-devel
    yum clean all
}

cd /tmp

## civetweb
wget -qO civetweb-${CIVETWEB_VERSION}.tar.gz https://github.com/civetweb/civetweb/archive/v${CIVETWEB_VERSION}.tar.gz
tar -xf civetweb-${CIVETWEB_VERSION}.tar.gz

pushd civetweb-${CIVETWEB_VERSION}

mkdir build && cd build

# https://github.com/conan-io/conan-center-index/blob/master/recipes/civetweb/all/conanfile.py
cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local -DROARING_DISABLE_AVX=True -DROARING_DISABLE_AVX512=True -DROARING_DISABLE_NEON=True -DROARING_DISABLE_NATIVE=False -DROARING_BUILD_STATIC=True -DENABLE_ROARING_TESTS=False
make -j$(nproc)
make install

popd

rm -rf civetweb-${CIVETWEB_VERSION} civetweb-${CIVETWEB_VERSION}.tar.gz

## prometheus-cpp
wget -qO prometheus-cpp-${PROMETHEUS-CPP_VERSION}.tar.gz https://github.com/SRombauts/SQLiteCpp/archive/refs/tags/v${PROMETHEUS-CPP_VERSION}.tar.gz
tar -xf prometheus-cpp-${PROMETHEUS-CPP_VERSION}.tar.gz

pushd prometheus-cpp-${PROMETHEUS-CPP_VERSION}

mkdir build && cd build

# https://github.com/conan-io/conan-center-index/blob/master/recipes/prometheus-cpp/all/conanfile.py
cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local -DUSE_THIRDPARTY_LIBRARIES=False -DENABLE_TESTING=False -DENABLE_PULL=False -DENABLE_PUSH=True
make -j$(nproc)
make install

popd

rm -rf prometheus-cpp-${PROMETHEUS-CPP_VERSION} prometheus-cpp-${PROMETHEUS-CPP_VERSION}.tar.gz

which ldconfig && ldconfig || true