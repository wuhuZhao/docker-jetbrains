From hkzhao123/projector-clion:1.0.0
MAINTAINER haokaizhao

USER root
RUN ln -fs /bin/bash /bin/sh
RUN apt install -y build-essential autoconf libtool pkg-config
RUN git clone --recurse-submodules -b v1.38.0 https://github.com/grpc/grpc /root/grpc/
WORKDIR /root/grpc
RUN mkdir -p cmake/build
WORKDIR /root/grpc/cmake/build
RUN cmake -DgRPC_INSTALL=ON -DgRPC_BUILD_TESTS=OFF -DCMAKE_INSTALL_PREFIX=$MY_INSTALL_DIR ../..
RUN make -j 
RUN make install
WORKDIR /root/grpc
RUN mkdir -p third_party/abseil-cpp/cmake/build
WORKDIR /root/grpc/third_party/abseil-cpp/cmake/build
RUN cmake -DCMAKE_INSTALL_PREFIX=$MY_INSTALL_DIR -DCMAKE_POSITION_INDEPENDENT_CODE=TRUE ../..
RUN make -j
RUN make install
RUN echo "ok"



