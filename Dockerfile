FROM nvcr.io/nvidia/cuda:11.7.1-runtime-ubuntu22.04
RUN apt-get update && apt-get install -y \
    wget \
    git \
    sudo \
    build-essential
WORKDIR /opt

RUN wget https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh && \
    git clone https://github.com/OpenFreeEnergy/openfe.git && \
    sh Miniforge3-Linux-x86_64.sh -b -p /opt/Miniforge3 && \
    rm -r Miniforge3-Linux-x86_64.sh

ENV PATH /opt/Miniforge3/bin:$PATH
WORKDIR /opt/openfe

RUN mamba env create -f environment.yml -y && \
    conda init && \
    activate openfe_env && \
    python -m pip install --no-deps . && \
    activate openfe_env && \
    conda clean --all -y && \
    pip cache purge && \
    conda clean --all -y && \
    echo "conda activate openfe_env" >> ~/.bashrc

SHELL ["conda", "run", "-n", "openfe_env", "/bin/bash", "-c"]
