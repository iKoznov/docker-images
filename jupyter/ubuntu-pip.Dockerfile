# https://medium.com/geekculture/creating-docker-image-conda-jupyter-notebook-for-social-scientists-8c8b8b259a9a

FROM ubuntu AS ikoznov_jupyter

ARG PYTHON_VERSION=3.12
ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /tmp

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        software-properties-common gnupg \
        build-essential libffi-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

#python${PYTHON_VERSION}-distutils \
RUN add-apt-repository -y ppa:deadsnakes/ppa \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        python${PYTHON_VERSION} \
        python${PYTHON_VERSION}-dev \
        python${PYTHON_VERSION}-venv \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV VIRTUAL_ENV=/opt/venv
RUN python${PYTHON_VERSION} -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

COPY requirements.txt /tmp
COPY requirements-pip.txt /tmp

RUN . /opt/venv/bin/activate \
    && python -m pip install \
    -r /tmp/requirements-pip.txt \
    -r /tmp/requirements.txt

RUN jupyter labextension disable "@jupyterlab/apputils-extension:announcements"
