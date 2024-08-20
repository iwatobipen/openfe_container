FROM nvidia/cuda:12.2.2-runtime-ubuntu22.04
RUN apt-get update && apt-get install -y \
    wget \
    git \
    vim \
    sudo \
    build-essential
WORKDIR /opt

#RUN wget https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh && \
RUN wget https://github.com/conda-forge/miniforge/releases/download/24.3.0-0/Mambaforge-24.3.0-0-Linux-x86_64.sh && \
    git clone https://github.com/OpenFreeEnergy/openfe.git && \
    #sh Miniforge3-Linux-x86_64.sh -b -p /opt/Miniforge3 && \
    #rm -r Miniforge3-Linux-x86_64.sh
    sh Mambaforge-24.3.0-0-Linux-x86_64.sh -b -p /opt/Mambaforge && \
    rm -r Mambaforge-24.3.0-0-Linux-x86_64.sh

ENV PATH /opt/Mambaforge/bin:$PATH
WORKDIR /opt/openfe

RUN mamba env create -f environment.yml -y && \
    conda init
SHELL ["conda", "run", "-n", "openfe_env", "/bin/bash", "-c"]

RUN pip install --no-deps . && \
    mamba install -c conda-forge ambertools && \
    conda clean --all -y && \
    pip cache purge && \
    conda clean --all -y && \
    echo "conda activate openfe_env" >> ~/.bashrc
ENV PATH /opt/Mambaforge/envs/openfe_env/bin:$PATH
