#!/bin/bash

set -ex

VERSION=4.13.1

cd /tmp

wget -qO antlr4-${VERSION}.tar.gz https://github.com/SRombauts/SQLiteCpp/archive/refs/tags/${VERSION}.tar.gz
tar -xf antlr4-${VERSION}.tar.gz

pushd antlr4-${VERSION}/runtime/Cpp

mkdir build && cd build

# https://github.com/conan-io/conan-center-index/blob/master/recipes/antlr4-cppruntime/all/conanfile.py
cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local -DANTLR4_INSTALL=True -DWITH_LIBCXX=True -DANTLR_BUILD_CPP_TESTS=False -DWITH_DEMO=False -DANTLR_BUILD_SHARED=False -DANTLR_BUILD_STATIC=True
make -j$(nproc)
make install

popd

rm -rf antlr4-${VERSION} antlr4-${VERSION}.tar.gz

which ldconfig && ldconfig || true