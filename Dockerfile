FROM docker.io/rocm/rocm-terminal

# Rootless containers running as root have user permissions
# This avoids file permission issues when using bind mounts 
USER root

ENV SD_WORKDIR=/sd
WORKDIR $SD_WORKDIR

# Update system
RUN apt update && apt -y upgrade
# Repository for modern python versions
RUN apt install -y software-properties-common && add-apt-repository -y ppa:deadsnakes/ppa
# Install modern python
ENV PYTHON_VERSION_SHORT=3.9
RUN apt install -y python${PYTHON_VERSION_SHORT} python3-pip python${PYTHON_VERSION_SHORT}-distutils python${PYTHON_VERSION_SHORT}-venv \
 && update-alternatives --install /usr/bin/python python $(which python${PYTHON_VERSION_SHORT}) 9999 \
 && update-alternatives --install /usr/bin/python3 python3 $(which python${PYTHON_VERSION_SHORT}) 9999 \
 && update-alternatives --install /usr/bin/pip pip $(which pip3) 9999 \
 && pip install --upgrade pip distlib setuptools
# Needed for opencv
RUN apt install -y libgl1

# Gradio Setup
ENV PYTHONUNBUFFERED=1
ENV GRADIO_SERVER_NAME=0.0.0.0
ENV GRADIO_SERVER_PORT=7860
EXPOSE 7860

# Expose configuration files
RUN mkdir $SD_WORKDIR/config \
 && touch $SD_WORKDIR/config/config.json && ln -sf $SD_WORKDIR/config/config.json $SD_WORKDIR/config.json \
 && touch $SD_WORKDIR/config/styles.csv && ln -sf $SD_WORKDIR/config/styles.csv $SD_WORKDIR/config.json

# Setup venv
ENV VIRTUAL_ENV=$SD_WORKDIR/venv
RUN python -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

COPY . $SD_WORKDIR

ENTRYPOINT ["/bin/bash", "entrypoint.sh"]