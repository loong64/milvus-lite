#!/bin/bash

set -ex

VERSION=3.0.0

cd /tmp

wget -qO CRoaring-${VERSION}.tar.gz https://github.com/RoaringBitmap/CRoaring/archive/refs/tags/v${VERSION}.tar.gz
tar -xf CRoaring-${VERSION}.tar.gz

pushd CRoaring-${VERSION}

mkdir build && cd build

# https://github.com/conan-io/conan-center-index/blob/master/recipes/roaring/all/conanfile.py
cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local -DROARING_DISABLE_AVX=True -DROARING_DISABLE_AVX512=True -DROARING_DISABLE_NEON=True -DROARING_DISABLE_NATIVE=False -DROARING_BUILD_STATIC=True -DENABLE_ROARING_TESTS=False
make -j$(nproc)
make install

popd

rm -rf CRoaring-${VERSION} CRoaring-${VERSION}.tar.gz

which ldconfig && ldconfig || true