FROM runpod/pytorch:3.10-2.0.1-118-devel

# Make python 3.10 as default and create an environment
RUN : \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        software-properties-common \
    && add-apt-repository -y ppa:deadsnakes \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        build-essential \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        wget \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        ffmpeg \    
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && :

# install conda because of pytorch3d
ENV CONDA_DIR /opt/conda
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && /bin/bash ~/miniconda.sh -b -p /opt/conda
ENV PATH=$CONDA_DIR/bin:$PATH

WORKDIR /workspace

# dependency - bark
# COPY environment.yml .
# RUN conda env create -f environment.yml
RUN conda create --name bark python=3.10

# Make RUN commands use the new environment:
SHELL ["conda", "run", "-n", "bark", "/bin/bash", "-c"]

# Install bark
RUN git clone https://github.com/yic03685/bark-with-voice-clone.git

WORKDIR /workspace/bark-with-voice-clone
RUN pip install .
RUN pip install IPython

ENV CUDA_HOME=/usr/local/cuda-11.8

# This repo uses RVC as a submodule
RUN git clone https://github.com/yic03685/Retrieval-based-Voice-Conversion-WebUI.git

WORKDIR /workspace/bark-with-voice-clone/Retrieval-based-Voice-Conversion-WebUI
RUN pip install -r requirements.txt
RUN pip install nltk
COPY ./pretrained/hubert_base.pt /workspace/bark-with-voice-clone
COPY ./pretrained/rmvpe.pt /workspace/bark-with-voice-clone

# I have to temp save this file to RVC because I cannot fork the bark-clone repo
RUN cp bark_integration/generate.py ../

# Clone another common repo to get other integration utils
RUN mkdir -m 700 /root/.ssh; \
  touch -m 600 /root/.ssh/known_hosts; \
  ssh-keyscan github.com > /root/.ssh/known_hosts

WORKDIR /workspace/bark-with-voice-clone/
RUN --mount=type=ssh,id=github git clone -b master git@github.com:yic03685/LearningBuddyCommon.git

# Switch back to the main working space
WORKDIR /workspace/bark-with-voice-clone/








WORKDIR /workspace/bark-with-voice-clone

