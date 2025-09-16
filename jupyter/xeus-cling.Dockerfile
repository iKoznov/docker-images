#FROM continuumio/anaconda3
#FROM mambaorg/micromamba
FROM condaforge/mambaforge AS ikoznov_jupyter

WORKDIR /tmp

COPY requirements.txt /tmp
COPY requirements-mamba.txt /tmp

RUN mamba install -y -c conda-forge \
    --file /tmp/requirements-mamba.txt \
    --file /tmp/requirements.txt

RUN jupyter labextension disable \
    "@jupyterlab/apputils-extension:announcements"
