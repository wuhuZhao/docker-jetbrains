From hkzhao123/projector-clion:1.0.0
MAINTAINER haokaizhao

USER root
RUN export MY_INSTALL_DIR=/root/grpc/
RUN export PATH="$MY_INSTALL_DIR/bin:$PATH"
RUN ln -fs /bin/bash /bin/sh
RUN apt install -y build-essential autoconf libtool pkg-config
RUN pwd
RUN git clone --recurse-submodules -b v1.38.0 https://github.com/grpc/grpc /root/grpc/
RUN ls -lah
WORKDIR /root/grpc
RUN ls -lah
RUN mkdir -p cmake/build
RUN ls -lah cmake
# RUN pushd cmake/build
RUN ls -lah 
RUN cmake -DgRPC_INSTALL=ON -DgRPC_BUILD_TESTS=OFF -DCMAKE_INSTALL_PREFIX=$MY_INSTALL_DIR ./
RUN make -j
RUN make install
# RUN popd
RUN mkdir -p third_party/abseil-cpp/cmake/build
RUN pushd third_party/abseil-cpp/cmake/build
RUN cmake -DCMAKE_INSTALL_PREFIX=$MY_INSTALL_DIR -DCMAKE_POSITION_INDEPENDENT_CODE=TRUE ./
RUN make -j
RUN make install
# RUN popd
RUN echo "ok"



