#!/bin/bash

set -ex

VERSION=1.12.0

command -v yum >/dev/null && {
    yum install -y openblas-devel gflags-devel
    yum clean all
}

cd /tmp

wget -qO faiss-${VERSION}.tar.gz https://github.com/facebookresearch/faiss/archive/refs/tags/v${VERSION}.tar.gz
tar -xf faiss-${VERSION}.tar.gz

pushd faiss-${VERSION}

mkdir build && cd build

# https://github.com/conan-io/conan-center-index/blob/master/recipes/faiss/all/conanfile.py
cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local -DFAISS_ENABLE_GPU=False -DBUILD_TESTING=False -DFAISS_ENABLE_PYTHON=False -DCMAKE_TRY_COMPILE_CONFIGURATION=Release
make -j$(nproc)
make install

popd

rm -rf faiss-${VERSION} faiss-${VERSION}.tar.gz

which ldconfig && ldconfig || true