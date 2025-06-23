#FROM menci/archlinuxarm as ikoznov_arch
FROM gmanka/archlinuxarm as ikoznov_arch

RUN pacman -Syu --noconfirm

RUN pacman -Syu --noconfirm  \
    base-devel git
RUN useradd -m builder && \
    echo "builder ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
USER builder
WORKDIR /home/builder
RUN git clone https://aur.archlinux.org/yay.git && \
    cd yay && makepkg -si --noconfirm
RUN yay -S --noconfirm clang lld llvm llvm-libs llvm-tools libc++
USER root

RUN pacman -Syu --noconfirm  \
    cmake ninja make  \
    gdb lldb mold  \
    git-lfs curl wget
    #gcc clang libc++ mold

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

#ENV CC="/usr/bin/clang"
#ENV CXX="/usr/bin/clang++"
