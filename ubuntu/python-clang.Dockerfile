# https://medium.com/geekculture/creating-docker-image-conda-jupyter-notebook-for-social-scientists-8c8b8b259a9a

FROM ghcr.io/ikoznov/ubuntu/ubuntu-base:main AS ikoznov_python_clang

ARG PYTHON_VERSION=3.12
ARG CLANG_VERSION=18
ARG DEBIAN_FRONTEND=noninteractive

RUN add-apt-repository -y ppa:deadsnakes/ppa \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        python${PYTHON_VERSION} \
        python${PYTHON_VERSION}-dev \
        python${PYTHON_VERSION}-venv \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
    #python${PYTHON_VERSION}-distutils

#RUN /bin/bash -c "$(wget -O - https://apt.llvm.org/llvm.sh)" all ${CLANG_VERSION} \
RUN /bin/bash -c "$(wget -O - https://apt.llvm.org/llvm.sh)" all ${CLANG_VERSION} \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        clang-tools-${CLANG_VERSION} \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
        #lld-${CLANG_VERSION}
        #lldb-${CLANG_VERSION}
