#!/bin/bash

set -ex

SQLITECPP_VERSION=3.3.1

command -v yum >/dev/null && {
    yum install -y sqlite-devel
    yum clean all
}

cd /tmp

wget -qO SQLiteCpp-${SQLITECPP_VERSION}.tar.gz https://github.com/SRombauts/SQLiteCpp/archive/refs/tags/${SQLITECPP_VERSION}.tar.gz
tar -xf SQLiteCpp-${SQLITECPP_VERSION}.tar.gz

pushd SQLiteCpp-${SQLITECPP_VERSION}

mkdir build && cd build

# https://github.com/conan-io/conan-center-index/blob/master/recipes/sqlitecpp/all/conanfile.py
cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local -DSQLITECPP_INTERNAL_SQLITE=False -DSQLITECPP_RUN_CPPLINT=False -DSQLITECPP_RUN_CPPCHECK=False -DSQLITECPP_RUN_DOXYGEN=False -DSQLITECPP_BUILD_EXAMPLES=False -DSQLITECPP_BUILD_TESTS=False -DSQLITECPP_USE_STACK_PROTECTION=True -DSQLITE_HAS_CODEC=False
make -j$(nproc)
make install

popd

rm -rf SQLiteCpp-${SQLITECPP_VERSION} SQLiteCpp-${SQLITECPP_VERSION}.tar.gz

which ldconfig && ldconfig || true