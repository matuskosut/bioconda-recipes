
set -e
set -x

export LIBRARY_PATH="${LIBRARY_PATH}:${PREFIX}/lib:${PREFIX}/lib64"
export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${PREFIX}/lib:${PREFIX}/lib64"
#export DYLD_LIBRARY_PATH=${PREFIX}/lib

mkdir -p build
cd build

if [[ $(uname -s) == Darwin ]]; then
  RPATH='@loader_path/../lib'
else
  ORIGIN='$ORIGIN'
  export ORIGIN
  RPATH='$${ORIGIN}/../lib:$${ORIGIN}/../lib64'
fi
LDFLAGS='-Wl,-rpath,${RPATH}'

cmake \
  -DBUILD_SHARED_LIBS:BOOL=ON \
  -DCMAKE_PREFIX_PATH:PATH=${PREFIX} \
  -DCMAKE_INSTALL_PREFIX:PATH=${PREFIX} \
  -DCMAKE_INSTALL_LIBDIR=lib \
  -DCMAKE_BUILD_TYPE="Release" \
  -DUSE_CXX3_ABI=ON \
  -DBUILD_TESTS=ON \
  -DCMAKE_EXE_LINKER_FLAGS="-static-libgcc -static-libstdc++" \
  ${SRC_DIR}

make -j${CPU_COUNT} savvy
make -j${CPU_COUNT} sav
make -j${CPU_COUNT} savvy-test
make install
make test
cd ..
