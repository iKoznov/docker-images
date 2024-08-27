# https://medium.com/geekculture/creating-docker-image-conda-jupyter-notebook-for-social-scientists-8c8b8b259a9a

#FROM ghcr.io/ikoznov/ubuntu/python-clang:main as ikoznov_jupyter
FROM ubuntu as ikoznov_jupyter

# TODO: use buildpack base images
#       https://github.com/devcontainers/images/blob/main/src/base-ubuntu/.devcontainer/Dockerfile
# ARG VARIANT="noble"
# FROM buildpack-deps:${VARIANT}-curl

#ARG MY_USERNAME=developer
ARG MY_ADMINUSER=admin
ARG MY_PYTHON_VERSION=3.12
ARG MY_CLANG_VERSION=18
ARG MY_VIRTUAL_ENV=/opt/venv
#WORKDIR /tmp

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update  \
    && apt-get upgrade -y  \
    && apt-get install -y --no-install-recommends  \
        lsb-release software-properties-common gnupg  \
        pipx wget curl git git-lfs gdb  \
        zsh sudo tree htop mc  \
    && apt-get autoremove -y  \
    && apt-get clean  \
    && rm -rf /var/lib/apt/lists/*
    #build-essential libffi-dev
    #python3 python3-venv python3-pip

#RUN add-apt-repository -y ppa:deadsnakes/ppa  \
#    && apt-get update  \
#    && apt-get install -y --no-install-recommends  \
#        python${MY_PYTHON_VERSION}  \
#        python${MY_PYTHON_VERSION}-dev  \
#        python${MY_PYTHON_VERSION}-venv  \
#    && apt-get clean  \
#    && rm -rf /var/lib/apt/lists/*
#    #python${MY_PYTHON_VERSION}-distutils

#RUN /bin/bash -c "$(wget -O - https://apt.llvm.org/llvm.sh)" all ${MY_CLANG_VERSION}  \
#    && apt-get install -y --no-install-recommends  \
#        clang-tools-${MY_CLANG_VERSION}  \
#    && apt-get clean  \
#    && rm -rf /var/lib/apt/lists/*
#        #lld-${MY_CLANG_VERSION}
#        #lldb-${MY_CLANG_VERSION}
#        #llvm-${MY_CLANG_VERSION}-linker-tools

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


# https://github.com/pypa/pipx/issues/754#issuecomment-1185923648
#TODO: RUN pipx ensurepath --global
#ENV PIPX_GLOBAL_HOME="/opt/pipx"
#ENV PIPX_GLOBAL_BIN_DIR="/usr/local/bin"
#ENV PATH="/root/.local/bin:${PATH}"
ENV PIPX_HOME="/opt/pipx"
ENV PIPX_BIN_DIR="/usr/local/bin"

RUN pipx install "conan>=2.0,<3.0" --include-deps  \
    && conan --version
    #--python python${MY_PYTHON_VERSION}

#RUN pipx install "cmake>=3.28,<4.0" --include-deps  \
#    && update-alternatives --install /usr/bin/cmake cmake "${PIPX_BIN_DIR}/cmake" 1 --force  \
#    && update-alternatives --install /usr/bin/ctest ctest "${PIPX_BIN_DIR}/ctest" 1 --force  \
#    && update-alternatives --install /usr/bin/cpack cpack "${PIPX_BIN_DIR}/cpack" 1 --force  \
#    && cmake --version

#RUN pipx install "ninja>=1.11" --include-deps  \
#    && ninja --version

#RUN pipx install "mold" --include-deps  \
#    && mold --version

#RUN pipx install "sccache" --include-deps  \
#    && sccache --version

RUN pipx install "jupyterlab" --include-deps  \
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

# Maybe install homebrew with install script and rc file
# https://dev.to/jdxlabs/github-actions-to-deploy-your-terraform-code-50n9
#   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
#   rc=/tmp/rcfile && touch $rc
#   echo 'eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)' >> $rc
#   source /tmp/rcfile
RUN curl -L https://github.com/Homebrew/brew/tarball/master  \
    | tar xz --strip-components 1 -C /home/linuxbrew/.linuxbrew
#    && chown -R linuxbrew /home/linuxbrew/.linuxbrew

RUN eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"  \
    && brew update --force --quiet  \
    && brew --version
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
RUN brew install llvm@${MY_CLANG_VERSION}  \
    && brew cleanup --prune=all

#RUN brew install swift  \
#    && brew cleanup --prune=all

RUN brew install python@${MY_PYTHON_VERSION}  \
    && brew cleanup --prune=all

#&& update-alternatives --install /usr/bin/cmake cmake /home/linuxbrew/.linuxbrew/opt/cmake/bin/cmake 1 --force  \
#&& update-alternatives --install /usr/bin/ctest ctest /home/linuxbrew/.linuxbrew/opt/cmake/bin/ctest 1 --force  \
#&& update-alternatives --install /usr/bin/cpack cpack /home/linuxbrew/.linuxbrew/opt/cmake/bin/cpack 1 --force  \
RUN brew install cmake ninja make mold ccache  \
    && brew cleanup --prune=all

USER 0

RUN update-alternatives --install /usr/bin/cmake cmake /home/linuxbrew/.linuxbrew/bin/cmake 1 --force  \
    && update-alternatives --install /usr/bin/ctest ctest /home/linuxbrew/.linuxbrew/bin/ctest 1 --force  \
    && update-alternatives --install /usr/bin/cpack cpack /home/linuxbrew/.linuxbrew/bin/cpack 1 --force

RUN python${MY_PYTHON_VERSION} -m venv ${MY_VIRTUAL_ENV}
#ENV PATH="${MY_VIRTUAL_ENV}/bin:${PATH}"

COPY requirements-cpp.txt /tmp
# python -m pip install setuptools
RUN . ${MY_VIRTUAL_ENV}/bin/activate  \
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
#ENV CC="/usr/bin/clang-${MY_CLANG_VERSION}"
#ENV CXX="/usr/bin/clang++-${MY_CLANG_VERSION}"
#ENV CC="/home/linuxbrew/.linuxbrew/opt/llvm/bin/clang"
#ENV CXX="/home/linuxbrew/.linuxbrew/opt/llvm/bin/clang++"
ENV CC="/home/linuxbrew/.linuxbrew/bin/clang"
ENV CXX="/home/linuxbrew/.linuxbrew/bin/clang++"

#COPY conan_config /tmp/conan_config
#CMD conan config install /tmp/conan_config -t dir

#ENTRYPOINT ["/bin/bash", "-c"]
