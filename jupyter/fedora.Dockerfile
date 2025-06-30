# Start with base Fedora image
FROM fedora:latest as ikoznov_fedora

ARG MY_VIRTUAL_ENV=/opt/venv

# Update the system and install Clang
RUN dnf update -y && \
    dnf install -y \
        clang clang-tools-extra \
        llvm lld compiler-rt \
        libcxx-devel \
    && dnf clean all

RUN clang --version

RUN dnf update -y && \
    dnf install -y \
        ninja make  \
        gdb lldb mold  \
        git-lfs curl wget  \
    && dnf clean all

RUN ninja --version
RUN mold --version

RUN dnf update -y && \
    dnf install -y \
        pkgconf autoconf automake libtoolize  \
        perl sed awk

RUN pkg-config --version
RUN automake --version
RUN autoconf --version
RUN autoreconf --version
RUN libtoolize --version

RUN dnf update -y && \
    dnf install -y \
        python3 ping nmap nmap-ncat \
        openssl-devel

RUN python3 --version
RUN nmap --version
RUN nc --version

ENV PIPX_BIN_DIR="/usr/local/bin"
RUN dnf update -y && \
    dnf install -y  \
        pipx which &&  \
    pipx ensurepath --global

RUN pipx install --global  \
    "conan>=2.0" --include-deps
RUN conan --version

RUN pipx install --global  \
    "cmake>=4.0" --include-deps
RUN ln -sf "${PIPX_BIN_DIR}/cmake" /usr/bin/cmake
RUN ln -sf "${PIPX_BIN_DIR}/ctest" /usr/bin/ctest
RUN ln -sf "${PIPX_BIN_DIR}/cpack" /usr/bin/cpack
RUN cmake --version

RUN pipx install --global  \
    "supervisor" --include-deps
RUN supervisord --version

RUN pipx install --global  \
    "superlance" --include-deps

RUN dnf update -y && \
    dnf install -y \
        systemd-devel libglvnd-devel libfontenc-devel \
        libXaw-devel libXcomposite-devel libXcursor-devel libXdmcp-devel libXtst-devel  \
        libXinerama-devel libxkbfile-devel libXrandr-devel libXres-devel libXScrnSaver-devel  \
        xcb-util-wm-devel xcb-util-image-devel xcb-util-keysyms-devel xcb-util-renderutil-devel  \
        libXdamage-devel libXxf86vm-devel libXv-devel xcb-util-devel libuuid-devel xcb-util-cursor-devel

RUN python3 -m venv ${MY_VIRTUAL_ENV}

COPY requirements-cpp.txt /tmp
RUN . ${MY_VIRTUAL_ENV}/bin/activate  \
    && python -m pip install  \
        -r /tmp/requirements-cpp.txt  \
    && python -m pip cache remove "*"  \
    && deactivate

ENV PATH="${MY_VIRTUAL_ENV}/bin:${PATH}"
ENV CC="/usr/bin/clang"
ENV CXX="/usr/bin/clang++"
