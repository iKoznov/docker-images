# https://saturncloud.io/blog/is-it-possible-to-run-a-pypy-kernel-in-the-jupyter-notebook/

##FROM continuumio/anaconda3
##FROM mambaorg/micromamba
#FROM condaforge/mambaforge
#
#COPY requirements.txt /tmp
#COPY requirements-pypy.txt /tmp
#
#RUN mamba install -y -c conda-forge \
#    --file /tmp/requirements-pypy.txt \
#    --file /tmp/requirements.txt
#    # pypy_kernel
#
##RUN pip install ipykernel
#
#RUN jupyter labextension disable \
#    "@jupyterlab/apputils-extension:announcements"

FROM ubuntu:latest

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -f -y --no-install-recommends \
    pypy3 pypy3-dev pypy3-venv build-essential

ENV VIRTUAL_ENV=/opt/venv
RUN pypy3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

COPY requirements.txt /tmp
COPY requirements-pip.txt /tmp

RUN . /opt/venv/bin/activate \
    && pypy3 -m pip install \
    -r /tmp/requirements-pip.txt \
    -r /tmp/requirements.txt

RUN jupyter labextension disable "@jupyterlab/apputils-extension:announcements"
