#!/bin/bash

set -ex

VERSION=f9d53419e912910fd8fa57d5705fa41425428c35

cd /tmp

wget -qO rapidjson-${VERSION}.tar.gz https://github.com/Tencent/rapidjson/archive/${VERSION}.tar.gz
tar -xf rapidjson-${VERSION}.tar.gz

pushd rapidjson-${VERSION}

mkdir build && cd build

# https://github.com/conan-io/conan-center-index/blob/master/recipes/rapidjson/all/conanfile.py
cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local
make -j$(nproc)
make install

popd

rm -rf rapidjson-${VERSION} rapidjson-${VERSION}.tar.gz

which ldconfig && ldconfig || true