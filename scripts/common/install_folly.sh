#!/bin/bash

set -ex

LIBEVENT_VERSION=2.1.12
GLOG_VERSION=0.6.0
FOLLY_VERSION=2023.10.30.00

command -v yum >/dev/null && {
    yum install -y boost-devel bzip2-devel double-conversion-devel gflags-devel openssl-devel lz4-devel snappy-devel zlib-devel libzstd-devel libdwarf-devel libsodium-devel xz-devel libunwind-devel liburing-devel fmt-devel
    yum clean all
}

cd /tmp

## libevent
mkdir -p libevent-${LIBEVENT_VERSION}

wget -qO libevent-${LIBEVENT_VERSION}.tar.gz https://github.com/SRombauts/SQLiteCpp/archive/refs/tags/release-${LIBEVENT_VERSION}-stable.tar.gz
tar -xf libevent-${LIBEVENT_VERSION}.tar.gz -C libevent-${LIBEVENT_VERSION} --strip-components=1

pushd libevent-${LIBEVENT_VERSION}

mkdir build && cd build

# https://github.com/conan-io/conan-center-index/blob/master/recipes/libevent/all/conanfile.py
cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local -DEVENT__DISABLE_DEBUG_MODE=True -DEVENT__DISABLE_OPENSSL=False -DEVENT__DISABLE_THREAD_SUPPORT=False -DEVENT__DISABLE_BENCHMARK=True -DEVENT__DISABLE_TESTS=True -DEVENT__DISABLE_REGRESS=True -DEVENT__DISABLE_SAMPLES=True
make -j$(nproc)
make install

popd

rm -rf libevent-${LIBEVENT_VERSION} libevent-${LIBEVENT_VERSION}.tar.gz

## glog
wget -qO glog-${GLOG_VERSION}.tar.gz https://github.com/google/glog/archive/refs/tags/v${FOLLY_VERSION}.tar.gz
tar -xf glog-${GLOG_VERSION}.tar.gz

pushd glog-${FOLLY_VERSION}

mkdir build && cd build

# https://github.com/conan-io/conan-center-index/blob/master/recipes/glog/all/conanfile.py
cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local -DWITH_GFLAGS=True -DWITH_THREADS=True -WITH_PKGCONFIGD=True -DWITH_SYMBOLIZE=True -DWITH_UNWIND=True -DBUILD_TESTING=False -DWITH_GTEST=False -DCMAKE_TRY_COMPILE_CONFIGURATION=Release
make -j$(nproc)
make install

popd

rm -rf glog-${FOLLY_VERSION} glog-${FOLLY_VERSION}.tar.gz

## folly
wget -qO folly-${FOLLY_VERSION}.tar.gz https://github.com/SRombauts/SQLiteCpp/archive/refs/tags/v${FOLLY_VERSION}.tar.gz
tar -xf folly-${FOLLY_VERSION}.tar.gz

pushd folly-${FOLLY_VERSION}

cd build

# https://github.com/conan-io/conan-center-index/blob/master/recipes/folly/all/conanfile.py
cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local -DCMAKE_TRY_COMPILE_CONFIGURATION=Release
make -j$(nproc)
make install

popd

rm -rf libevent-${LIBEVENT_VERSION} libevent-${LIBEVENT_VERSION}.tar.gz

which ldconfig && ldconfig || true

