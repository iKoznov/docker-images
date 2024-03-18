# https://medium.com/geekculture/creating-docker-image-conda-jupyter-notebook-for-social-scientists-8c8b8b259a9a

FROM ubuntu as ikoznov_jupyter

ARG USERNAME=developer
ARG PYTHON_VERSION=3.12
ARG CLANG_VERSION=18
ARG DEBIAN_FRONTEND=noninteractive
#WORKDIR /tmp

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        lsb-release software-properties-common gnupg \
        pipx wget curl git git-lfs gdb make \
        build-essential libffi-dev tree \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
    #build-essential libffi-dev tree
    #python3 python3-venv python3-pip

RUN add-apt-repository -y ppa:deadsnakes/ppa \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        python${PYTHON_VERSION} \
        python${PYTHON_VERSION}-dev \
        python${PYTHON_VERSION}-venv \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
    #python${PYTHON_VERSION}-distutils

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

# https://github.com/pypa/pipx/issues/754#issuecomment-1185923648
#TODO: RUN pipx ensurepath --global
#ENV PIPX_GLOBAL_HOME="/opt/pipx"
#ENV PIPX_GLOBAL_BIN_DIR="/usr/local/bin"
#ENV PATH="/root/.local/bin:${PATH}"
ENV PIPX_HOME="/opt/pipx"
ENV PIPX_BIN_DIR="/usr/local/bin"

RUN pipx install "conan>=2.0,<3.0" --include-deps \
    && conan --version
    #--python python${PYTHON_VERSION}

#RUN pipx install "cmake>=3.28,<4.0" --include-deps \
#    && update-alternatives --install /usr/bin/cmake cmake "${PIPX_BIN_DIR}/cmake" 1 --force \
#    && update-alternatives --install /usr/bin/ctest ctest "${PIPX_BIN_DIR}/ctest" 1 --force \
#    && update-alternatives --install /usr/bin/cpack cpack "${PIPX_BIN_DIR}/cpack" 1 --force \
#    && cmake --version

#RUN pipx install "ninja>=1.11" --include-deps \
#    && ninja --version

#RUN pipx install "mold" --include-deps \
#    && mold --version

#RUN pipx install "sccache" --include-deps \
#    && sccache --version

RUN pipx install "jupyterlab" --include-deps \
    && jupyter labextension disable "@jupyterlab/apputils-extension:announcements" \
    && jupyter --version

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

ENV VIRTUAL_ENV=/opt/venv
RUN python${PYTHON_VERSION} -m venv $VIRTUAL_ENV
#ENV PATH="$VIRTUAL_ENV/bin:$PATH"

COPY requirements-cpp.txt /tmp
RUN . ${VIRTUAL_ENV}/bin/activate \
    && python -m pip install \
        -r /tmp/requirements-cpp.txt \
    && python -m pip cache remove "*"

RUN useradd -ms /bin/bash ${USERNAME}
USER ${USERNAME}
WORKDIR /home/${USERNAME}

RUN . ${VIRTUAL_ENV}/bin/activate
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
ENV CC="/usr/bin/clang-${CLANG_VERSION}"
ENV CXX="/usr/bin/clang++-${CLANG_VERSION}"

#COPY conan_config /tmp/conan_config
#CMD conan config install /tmp/conan_config -t dir

#ENTRYPOINT ["/bin/bash", "-c"]
