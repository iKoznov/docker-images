#FROM menci/archlinuxarm as ikoznov_arch
FROM gmanka/archlinuxarm as ikoznov_arch

#ARG MY_USERNAME=developer
ARG MY_ADMINUSER=admin
#ARG MY_RUBY_VERSION=3.2.7
ARG MY_PYTHON_VERSION=3.13
ARG MY_CLANG_VERSION=20
ARG MY_NINJA_VERSION=1.12.1
ARG MY_MOLD_VERSION=2.39.1
ARG MY_VIRTUAL_ENV=/opt/venv
#WORKDIR /tmp

RUN pacman -Syu --noconfirm
RUN pacman -Syu --noconfirm  \
    gcc clang cmake ninja mold  \
    gdb lldb make  \
    git git-lfs

RUN clang --version
RUN cmake --version
RUN ninja --version
RUN mold --version

RUN pacman -Syu --noconfirm  \
    pkgconf autoconf automake

RUN pkg-config --version
RUN automake --version
RUN autoconf --version
RUN autoreconf --version
RUN libtoolize --version

RUN pacman -Syu --noconfirm  \
    python-pipx &&  \
    pipx ensurepath --global

RUN pipx install --global  \
    conan

RUN conan --version

RUN pacman -Syu --noconfirm  \
    libglvnd  \
    libfontenc libice libsm libxaw libxcomposite  \
    libxcursor libxdamage libxtst libxinerama libxkbfile libxrandr libxres libxss  \
    xcb-util-wm xcb-util-image xcb-util-keysyms xcb-util-renderutil libxv xcb-util xcb-util-cursor
