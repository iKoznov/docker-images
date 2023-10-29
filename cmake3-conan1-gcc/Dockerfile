FROM ubuntu:latest
ARG DEBIAN_FRONTEND=noninteractive

# https://hub.docker.com/r/linuxbrew/linuxbrew/dockerfile
RUN apt-get update \
	&& apt-get upgrade -y \
	&& apt-get install -y --no-install-recommends \
        software-properties-common \
        gpg-agent \
	&& add-apt-repository -y ppa:git-core/ppa \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends \
       build-essential \
#		bzip2 \
		ca-certificates \
		curl \
#		file \
		fonts-dejavu-core \
#		g++ \
		git \
		locales \
#		make \
		openssh-client \
#		patch \
		sudo \
#		uuid-runtime \
	&& rm -rf /var/lib/apt/lists/*

RUN localedef -i en_US -f UTF-8 en_US.UTF-8 \
	&& useradd -m -s /bin/bash linuxbrew \
	&& echo 'linuxbrew ALL=(ALL) NOPASSWD:ALL' >>/etc/sudoers
#ADD . /home/linuxbrew/.linuxbrew/Homebrew
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
RUN cd /home/linuxbrew/.linuxbrew \
#	&& mkdir -p bin etc include lib opt sbin share var/homebrew/linked Cellar \
#	&& ln -s ../Homebrew/bin/brew /home/linuxbrew/.linuxbrew/bin/ \
	&& chown -R linuxbrew: /home/linuxbrew/.linuxbrew \
	&& cd /home/linuxbrew/.linuxbrew/Homebrew \
    && git config --global --add safe.directory /home/linuxbrew/.linuxbrew/Homebrew \
	&& git remote set-url origin https://github.com/Linuxbrew/brew

USER linuxbrew
WORKDIR /home/linuxbrew
ENV PATH=/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:$PATH \
	SHELL=/bin/bash \
	USER=linuxbrew

ARG HOMEBREW_NO_ANALYTICS=1
ARG HOMEBREW_NO_AUTO_UPDATE=1

# Install portable-ruby and tap homebrew/core.
RUN brew tap homebrew/core \
	&& rm -rf ~/.cache

RUN brew install \
        conan@1 \
        ninja \
        cmake \
        gcc \
    && rm -rf ~/.cache
