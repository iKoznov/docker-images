# https://medium.com/geekculture/creating-docker-image-conda-jupyter-notebook-for-social-scientists-8c8b8b259a9a

#FROM ghcr.io/ikoznov/ubuntu/python-clang:main as ikoznov_jupyter
#FROM debian:latest as ikoznov_jupyter
#FROM debian:stable-slim as ikoznov_jupyter
#FROM debian:oldstable-slim as ikoznov_jupyter
FROM ubuntu:latest as ikoznov_jupyter
#FROM ubuntu:rolling as ikoznov_jupyter

# TODO: use buildpack base images
#       https://github.com/devcontainers/images/blob/main/src/base-ubuntu/.devcontainer/Dockerfile
# ARG VARIANT="noble"
# FROM buildpack-deps:${VARIANT}-curl

#ARG MY_USERNAME=developer
ARG MY_ADMINUSER=admin
#ARG MY_RUBY_VERSION=3.2.7
ARG MY_PYTHON_VERSION=3.13
ARG MY_CLANG_VERSION=20
ARG MY_MOLD_VERSION=2.37.1
ARG MY_VIRTUAL_ENV=/opt/venv
#WORKDIR /tmp

# This is needed to run jetbrains ide with devcontainers / alpine based images
# git wget unzip bash

ARG DEBIAN_FRONTEND=noninteractive
# this allows to donwload "apt-get build-dep" packages
# RUN sed -i 's/^Types: deb$/Types: deb deb-src/' /etc/apt/sources.list.d/ubuntu.sources \
# && apt-add-repository -y ppa:rael-gc/rvm  \

# https://docs.docker.com/build/cache/optimize
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked  \
    --mount=type=cache,target=/var/lib/apt,sharing=locked  \
    apt-get update  \
    && apt-get upgrade -yq  \
    && apt-get install -yq --no-install-recommends  \
        lsb-release software-properties-common gnupg  \
        wget curl unzip bash git git-lfs gdb  \
        pipx build-essential  \
        zlib1g-dev libffi-dev libssl-dev libreadline-dev sqlite3 libsqlite3-dev  \
        zsh sudo tree htop mc cmake mold
#mold
#RUN apt-get build-dep -yq  \
#        ruby-full python3

RUN apkArch="$(dpkg --print-architecture)";  \
    case "$apkArch" in  \
        arm64) export ARCH='aarch64' ;;  \
        amd64) export ARCH='x86_64' ;;  \
    esac;  \
    mkdir /opt/mold;  \
    wget -q -O - "https://github.com/rui314/mold/releases/download/v${MY_MOLD_VERSION}/mold-${MY_MOLD_VERSION}-${ARCH}-linux.tar.gz"  \
      | tar -xzf - -C /opt/mold --strip-components 1
ENV PATH /opt/mold/bin:$PATH
RUN mold --version

#RUN apt-get install ruby-full -yq
#RUN ruby --version && exit 1

#ENV PATH /opt/rbenv/shims:/opt/rbenv/bin:/opt/rbenv/plugins/ruby-build/bin:$PATH
#RUN git clone --depth 1 https://github.com/rbenv/rbenv.git /opt/rbenv
#RUN git clone --depth 1 https://github.com/rbenv/ruby-build.git /opt/rbenv/plugins/ruby-build
#RUN rbenv install ${MY_RUBY_VERSION} || cat /tmp/ruby-build.* || cat $(find /tmp | grep mkmf.log) && exit 1

# Install rbenv
#RUN git clone https://github.com/sstephenson/rbenv.git /usr/local/rbenv
#RUN tree /usr/local/rbenv && exit 2
#RUN echo '# rbenv setup' > /etc/profile.d/rbenv.sh
#RUN echo 'export RBENV_ROOT=/usr/local/rbenv' >> /etc/profile.d/rbenv.sh
#RUN echo 'export PATH="$RBENV_ROOT/bin:$PATH"' >> /etc/profile.d/rbenv.sh
#RUN echo 'eval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh
#RUN chmod +x /etc/profile.d/rbenv.sh

#RUN curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-installer | bash
#RUN echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> /root/.bashrc
#RUN echo 'eval "$(rbenv init -)"' >> /root/.bashrc
#
#RUN . /root/.bashrc && rbenv install 3.3.7

#    && apt-get autoremove -yq  \
#    && apt-get clean  \
#    && rm -rf /var/lib/apt/lists/*
    #build-essential libffi-dev pipx
    #python3 python3-venv python3-pip python3-virtualenv
    # Needed by ruby-build
    # libz-dev libssl-dev libffi-dev libyaml-dev

#RUN apt-get install rvm -y && find "/" -type "f" -name "rvm.sh"
#RUN /usr/share/rvm/scripts/rvm && rvm install ruby-${MY_RUBY_VERSION}

#RUN wget https://cache.ruby-lang.org/pub/ruby/$(shortversion=${MY_RUBY_VERSION%.*} printenv shortversion)/ruby-${MY_RUBY_VERSION}.tar.gz  \
#    && tar -xzf ruby-${MY_RUBY_VERSION}.tar.gz  \
#    && cd ruby-${MY_RUBY_VERSION}  \
#    && ./configure --disable-install-doc  \
#    && make -j$(nproc)  \
#    && make install  \
#    && ruby --version

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked  \
    --mount=type=cache,target=/var/lib/apt,sharing=locked  \
    add-apt-repository -y ppa:deadsnakes/ppa  \
    && apt-get update  \
    && apt-get install -y --no-install-recommends  \
        python${MY_PYTHON_VERSION}  \
        python${MY_PYTHON_VERSION}-dev  \
        python${MY_PYTHON_VERSION}-venv
#    && apt-get clean  \
#    && rm -rf /var/lib/apt/lists/*
    #python${MY_PYTHON_VERSION}-distutils

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked  \
    --mount=type=cache,target=/var/lib/apt,sharing=locked  \
    /bin/bash -c "$(wget -O - https://apt.llvm.org/llvm.sh)" all ${MY_CLANG_VERSION}  \
    && apt-get install -y --no-install-recommends  \
        clang-tools-${MY_CLANG_VERSION} libc++-${MY_CLANG_VERSION}-dev  \
    && update-alternatives --install /usr/bin/clang clang "/usr/bin/clang-${MY_CLANG_VERSION}" 1 --force  \
    && update-alternatives --install /usr/bin/clang++ clang++ "/usr/bin/clang++-${MY_CLANG_VERSION}" 1 --force
#    && apt-get clean  \
#    && rm -rf /var/lib/apt/lists/*
        #lld-${MY_CLANG_VERSION}
        #lldb-${MY_CLANG_VERSION}
        #llvm-${MY_CLANG_VERSION}-linker-tools

#RUN apt-get update  \
#    && apt-get install -y --no-install-recommends  \
#        llvmgold-${MY_CLANG_VERSION}  \
#    && ln -sf /usr/lib/LLVMgold.so /usr/lib/llvm-${MY_CLANG_VERSION}/lib/LLVMgold.so  \
#    && apt-get clean  \
#    && rm -rf /var/lib/apt/lists/*
#
#RUN apt-get update  \
#    && apt-get install -y --no-install-recommends  \
#        apt-file  \
#    && apt-file update  \
#    && apt-file find clang
#
#RUN ddsss
#
#RUN ls /usr/lib/LLVMgold.so >&2
#RUN ls /usr/lib/llvm-${MY_CLANG_VERSION}/lib/LLVMgold.so

#TODO: Try to use https://github.com/astral-sh/setup-uv to install python packages

# https://github.com/pypa/pipx/issues/754#issuecomment-1185923648
#TODO: RUN pipx ensurepath --global
#ENV PIPX_GLOBAL_HOME="/opt/pipx"
#ENV PIPX_GLOBAL_BIN_DIR="/usr/local/bin"
#ENV PATH="/root/.local/bin:${PATH}"
ENV PIPX_HOME="/opt/pipx"
ENV PIPX_BIN_DIR="/usr/local/bin"
#RUN if [ "true" = "true" ]; then \
#        apt-get update;  \
#    fi
#        apt-get update  \
#        && apt-get install -y --no-install-recommends  \
#            python3-pip python3-venv python3-dev  \
#        && python3 -m pip install --break-system-packages pipx  \
#        && apt-get autoremove -y  \
#        && apt-get clean  \
#        && rm -rf /var/lib/apt/lists/* \
#    }

RUN --mount=type=cache,target=/root/.cache/pip  \
    pipx install "conan>=2.0,<3.0" --include-deps  \
    && conan --version
    #--python python${MY_PYTHON_VERSION}

# downgrade cmake because of CMAKE_ROOT error
# pipx install "cmake>=3.28,!=3.31.*,<4.0" --include-deps
RUN --mount=type=cache,target=/root/.cache/pip  \
    pipx install "cmake>=4.0" --include-deps  \
    && update-alternatives --install /usr/bin/cmake cmake "${PIPX_BIN_DIR}/cmake" 1 --force  \
    && update-alternatives --install /usr/bin/ctest ctest "${PIPX_BIN_DIR}/ctest" 1 --force  \
    && update-alternatives --install /usr/bin/cpack cpack "${PIPX_BIN_DIR}/cpack" 1 --force  \
    && cmake --version

RUN --mount=type=cache,target=/root/.cache/pip  \
    pipx install "ninja>=1.11" --include-deps  \
    && ninja --version

#RUN --mount=type=cache,target=/root/.cache/pip  \
#    pipx install "mold" --include-deps  \
#    && mold --version

#RUN --mount=type=cache,target=/root/.cache/pip  \
#    pipx install "sccache" --include-deps  \
#    && sccache --version

RUN --mount=type=cache,target=/root/.cache/pip  \
    pipx install "jupyterlab" --include-deps  \
    && jupyter labextension disable "@jupyterlab/apputils-extension:announcements"  \
    && jupyter --version

RUN useradd -m ${MY_ADMINUSER} \
    && usermod -aG sudo ${MY_ADMINUSER} \
    && echo '${MY_ADMINUSER} ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

RUN mkdir -p /home/linuxbrew/.linuxbrew  \
    && chown -hR ${MY_ADMINUSER}: /home/linuxbrew

USER ${MY_ADMINUSER}
ENV PATH="/home/linuxbrew/.linuxbrew/bin:${PATH}"
ARG HOMEBREW_NO_ANALYTICS=1
ARG HOMEBREW_NO_AUTO_UPDATE=1
#ARG HOMEBREW_DEVELOPER=1
#ARG HOMEBREW_USE_RUBY_FROM_PATH=1

# TODO: linuxbrew arm unsupported
#       https://github.com/orgs/Homebrew/discussions/3612
#       https://docs.brew.sh/Homebrew-on-Linux#arm-unsupported

# Maybe install homebrew with install script and rc file
# https://dev.to/jdxlabs/github-actions-to-deploy-your-terraform-code-50n9
#   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
#   rc=/tmp/rcfile && touch $rc
#   echo 'eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)' >> $rc
#   source /tmp/rcfile
RUN curl -L https://github.com/Homebrew/brew/tarball/master  \
    | tar xz --strip-components 1 -C /home/linuxbrew/.linuxbrew
#    && chown -R linuxbrew /home/linuxbrew/.linuxbrew

#RUN eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"  \
#    && brew update --force --quiet  \
#    && brew --version
#RUN chmod -R go-w "$(brew --prefix)/share/zsh"

#RUN DEBIAN_FRONTEND=noninteractive /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"  \
#    && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"  \
#    && brew --version

#RUN git clone https://github.com/Homebrew/brew ~/.linuxbrew/Homebrew \
#    && mkdir ~/.linuxbrew/bin \
#    && ln -s ../Homebrew/bin/brew ~/.linuxbrew/bin \
#    && eval $(~/.linuxbrew/bin/brew shellenv) \
#    && brew --version

#ENV PATH="/home/linuxbrew/.linuxbrew/bin:${PATH}"

#&& update-alternatives --install /usr/bin/cmake cmake /home/linuxbrew/.linuxbrew/opt/cmake/bin/cmake 1 --force  \
#&& update-alternatives --install /usr/bin/ctest ctest /home/linuxbrew/.linuxbrew/opt/cmake/bin/ctest 1 --force  \
#&& update-alternatives --install /usr/bin/cpack cpack /home/linuxbrew/.linuxbrew/opt/cmake/bin/cpack 1 --force  \

#RUN brew install --build-from-source $(brew deps --include-build ninja) ninja

#RUN brew install --build-from-source  \
#    mpdecimal ca-certificates openssl@3  \
#    pkgconf gpatch ncurses readline zlib  \
#    sqlite xz berkeley-db@5 bzip2 lzip expat  \
#    libedit libffi unzip python@3.13

#RUN brew install --build-from-source mpdecimal
#RUN brew install --build-from-source openssl@3
#RUN brew install --build-from-source pkgconf
#RUN brew install --build-from-source gpatch
#RUN brew install --build-from-source ncurses
#RUN brew install --build-from-source readline
#RUN brew install --build-from-source zlib
#RUN brew install --build-from-source sqlite
#RUN brew install --build-from-source xz
#RUN brew install --build-from-source berkeley-db@5
#
#RUN brew install --build-from-source ninja  \
#    && brew cleanup --prune=all

#RUN brew install ninja make mold ccache  \
#    && brew cleanup --prune=all

#RUN brew install --build-from-source python@${MY_PYTHON_VERSION}  \
#    && brew cleanup --prune=all

#RUN brew install --build-from-source llvm@${MY_CLANG_VERSION}  \
#    && brew cleanup --prune=all

#RUN brew install ldc  \
#    && brew cleanup --prune=all

#RUN brew install --build-from-source swift  \
#    && brew cleanup --prune=all

USER 0

#RUN update-alternatives --install /usr/bin/cmake cmake /home/linuxbrew/.linuxbrew/bin/cmake 1 --force  \
#    && update-alternatives --install /usr/bin/ctest ctest /home/linuxbrew/.linuxbrew/bin/ctest 1 --force  \
#    && update-alternatives --install /usr/bin/cpack cpack /home/linuxbrew/.linuxbrew/bin/cpack 1 --force

RUN python${MY_PYTHON_VERSION} -m venv ${MY_VIRTUAL_ENV}
#ENV PATH="${MY_VIRTUAL_ENV}/bin:${PATH}"

COPY requirements-cpp.txt /tmp
# python -m pip install setuptools
RUN --mount=type=cache,target=/root/.cache/pip  \
    . ${MY_VIRTUAL_ENV}/bin/activate  \
    && python -m pip install  \
        -r /tmp/requirements-cpp.txt  \
    && python -m pip cache remove "*"  \
    && deactivate

# TODO: integrate into cmake python module testing with asan https://tobywf.com/2021/02/python-ext-asan/
#RUN git clone --depth 1 "https://github.com/tobywf/python-ext-asan.git" /tmp/python-ext-asan
#RUN . ${MY_VIRTUAL_ENV}/bin/activate
#ENV PATH="${MY_VIRTUAL_ENV}/bin:${PATH}"
#ENV CC="/home/linuxbrew/.linuxbrew/opt/llvm/bin/clang"
#ENV CXX="/home/linuxbrew/.linuxbrew/opt/llvm/bin/clang++"
#WORKDIR /tmp/python-ext-asan
#RUN python setup.py develop
#    RUN ldconfig -p  \
#    && LD_PRELOAD="/home/linuxbrew/.linuxbrew/opt/llvm/lib/clang/${MY_CLANG_VERSION}/lib/linux/libclang_rt.asan-x86_64.so:/lib/x86_64-linux-gnu/libstdc++.so.6"  \
#        python -c "import asan"

# running github actions with user other than root gets error: 'permission denied'
# https://github.com/actions/checkout/issues/1575
# https://github.com/actions/checkout/issues/956
# Officially, Github anyways says to use root inside the container...
# https://docs.github.com/en/enterprise-server@3.12/actions/creating-actions/dockerfile-support-for-github-actions#user
#RUN useradd -ms /bin/bash ${MY_USERNAME}
#USER ${MY_USERNAME}
#WORKDIR /home/${MY_USERNAME}

RUN . ${MY_VIRTUAL_ENV}/bin/activate
ENV PATH="${MY_VIRTUAL_ENV}/bin:${PATH}"
ENV CC="/usr/bin/clang-${MY_CLANG_VERSION}"
ENV CXX="/usr/bin/clang++-${MY_CLANG_VERSION}"
#ENV CC="/home/linuxbrew/.linuxbrew/opt/llvm/bin/clang"
#ENV CXX="/home/linuxbrew/.linuxbrew/opt/llvm/bin/clang++"
#ENV CC="/home/linuxbrew/.linuxbrew/bin/clang"
#ENV CXX="/home/linuxbrew/.linuxbrew/bin/clang++"
ENV CONAN_HOME="/root/.conan2"
#ENV CONAN_USER_HOME="/root"
ENV CCACHE_DIR="/root/.ccache"
#ENV SCCACHE_DIR="/root/.sccache"

#COPY conan_config /tmp/conan_config
#CMD conan config install /tmp/conan_config -t dir

#ENTRYPOINT ["/bin/bash", "-c"]
