# https://medium.com/geekculture/creating-docker-image-conda-jupyter-notebook-for-social-scientists-8c8b8b259a9a

FROM ubuntu:latest

ARG PYTHON_VERSION=3.12
ARG CLANG_VERSION=17
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -f -y \
        lsb-release software-properties-common gnupg wget \
        build-essential libffi-dev \
    && apt-get clean #libtbb-dev


RUN wget https://apt.llvm.org/llvm.sh \
    && chmod +x llvm.sh \
    && ./llvm.sh ${CLANG_VERSION} \
    && apt-get install -f -y \
        clang-tools-${CLANG_VERSION} \
    && apt-get clean

ENV CC=/usr/bin/clang-${CLANG_VERSION}
ENV CXX=/usr/bin/clang++-${CLANG_VERSION}

RUN add-apt-repository -y ppa:deadsnakes/ppa \
    && apt-get update \
    && apt-get install -y \
        python${PYTHON_VERSION} \
        python${PYTHON_VERSION}-dev \
        python${PYTHON_VERSION}-venv \
        python${PYTHON_VERSION}-distutils \
    && apt-get clean

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
