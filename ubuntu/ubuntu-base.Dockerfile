FROM ubuntu AS ikoznov_ubuntu

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        lsb-release software-properties-common gnupg \
        pipx wget curl git git-lfs gdb make \
        build-essential libffi-dev tree \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
    #build-essential libffi-dev tree
    #python3 python3-venv python3-pip
