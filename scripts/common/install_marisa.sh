#!/bin/bash

set -ex

VERSION=0.2.6

cd /tmp

wget -qO marisa-trie-${VERSION}.tar.gz https://github.com/s-yata/marisa-trie/archive/refs/tags/v${VERSION}.tar.gz
tar -xf marisa-trie-${VERSION}.tar.gz

pushd marisa-trie-${VERSION}

wget -qO - https://github.com/conan-io/conan-center-index/raw/refs/heads/master/recipes/marisa/all/patches/0001-add-cmake.patch | patch -p1

mkdir build && cd build

# https://github.com/conan-io/conan-center-index/blob/master/recipes/marisa/all/conanfile.py
cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local
make -j$(nproc)
make install

mkdir -p /usr/local/lib64/cmake/marisa
cat > /usr/local/lib64/cmake/marisa/marisaConfig.cmake << 'EOF'
# marisa CMake configuration file

set(MARISA_FOUND TRUE)
set(MARISA_INCLUDE_DIRS "/usr/local/include")
set(MARISA_LIBRARIES "/usr/local/lib64/libmarisa.a")

add_library(marisa::marisa STATIC IMPORTED)
set_target_properties(marisa::marisa PROPERTIES
  INTERFACE_INCLUDE_DIRECTORIES "${MARISA_INCLUDE_DIRS}"
  IMPORTED_LOCATION "${MARISA_LIBRARIES}"
)

set(VERSION_STRING "0.2.6")
set(VERSION_MAJOR 0)
set(VERSION_MINOR 2)
set(VERSION_PATCH 6)
EOF

popd

rm -rf marisa-trie-${VERSION} marisa-trie-${VERSION}.tar.gz

which ldconfig && ldconfig || true