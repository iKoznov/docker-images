# https://medium.com/geekculture/creating-docker-image-conda-jupyter-notebook-for-social-scientists-8c8b8b259a9a

FROM ubuntu as ikoznov_jupyter

ARG PYTHON_VERSION=3.12
ARG CLANG_VERSION=17
ARG DEBIAN_FRONTEND=noninteractive
WORKDIR /tmp

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        lsb-release software-properties-common gnupg \
        build-essential libffi-dev gdb \
        wget curl git git-lfs tree \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN add-apt-repository -y ppa:deadsnakes/ppa \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        python${PYTHON_VERSION} \
        python${PYTHON_VERSION}-dev \
        python${PYTHON_VERSION}-venv \
        python${PYTHON_VERSION}-distutils \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" \
    && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" \
    && brew --version

ENV PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
ARG HOMEBREW_NO_ANALYTICS=1
ARG HOMEBREW_NO_AUTO_UPDATE=1
RUN brew install \
        cmake ninja mold ccache \
    && update-alternatives --install /usr/bin/cmake cmake /home/linuxbrew/.linuxbrew/opt/cmake/bin/cmake 1 --force \
    && update-alternatives --install /usr/bin/ctest ctest /home/linuxbrew/.linuxbrew/opt/cmake/bin/ctest 1 --force \
    && update-alternatives --install /usr/bin/cpack cpack /home/linuxbrew/.linuxbrew/opt/cmake/bin/cpack 1 --force \
    && brew cleanup

RUN /bin/bash -c "$(wget -O - https://apt.llvm.org/llvm.sh)" ${CLANG_VERSION} \
    && apt-get install -y --no-install-recommends \
        clang-tools-${CLANG_VERSION} \
        lld-${CLANG_VERSION} \
        lldb-${CLANG_VERSION} \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV CC=/usr/bin/clang-${CLANG_VERSION}
ENV CXX=/usr/bin/clang++-${CLANG_VERSION}

ENV VIRTUAL_ENV=/opt/venv
RUN python${PYTHON_VERSION} -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

COPY requirements.txt /tmp
COPY requirements-pip.txt /tmp
COPY requirements-cpp.txt /tmp

RUN . /opt/venv/bin/activate \
    && python -m pip install \
        -r /tmp/requirements-cpp.txt \
        -r /tmp/requirements-pip.txt \
        -r /tmp/requirements.txt \
    && python -m pip cache remove "*"

RUN jupyter labextension disable "@jupyterlab/apputils-extension:announcements"
