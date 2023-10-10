#FROM continuumio/anaconda3
#FROM mambaorg/micromamba
FROM condaforge/mambaforge

COPY requirements.txt /tmp
COPY requirements-mamba.txt /tmp

RUN mamba install -y -c conda-forge \
        --file /tmp/requirements-mamba.txt \
        --file /tmp/requirements.txt \
    && mamba clean --all

RUN jupyter labextension disable \
    "@jupyterlab/apputils-extension:announcements"
