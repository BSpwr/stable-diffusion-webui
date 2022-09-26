FROM docker.io/rocm/pytorch:rocm5.2.3_ubuntu20.04_py3.7_pytorch_1.12.1

WORKDIR /sd

# Update system
RUN apt update && apt -y upgrade

ENV PYTHONUNBUFFERED=1
ENV GRADIO_SERVER_NAME=0.0.0.0
ENV GRADIO_SERVER_PORT=7860
EXPOSE 7860

RUN rm -rf /sd/models \
 && rm -rf /sd/outputs \
 && ln -s /models /sd \
 && ln -s /outputs /sd \
 && mkdir /config \
 && touch /config/config.json \
 && ln -s /config/config.json /sd/config.json

# Envars for installing dependencies at build time
ENV K_DIFFUSION_PACKAGE="git+https://github.com/crowsonkb/k-diffusion.git@1a0703dfb7d24d8806267c3e7ccc4caf67fd1331"
ENV GFPGAN_PACKAGE="git+https://github.com/TencentARC/GFPGAN.git@8d2447a2d918f8eba5a4a01463fd48e45126a379"
ENV CODEFORMER_REPO="https://github.com/sczhou/CodeFormer.git"
ENV CODEFORMER_COMMIT_HASH="c5b4593074ba6214284d6acd5f1719b6c5d739af"
ENV REQS_FILE="requirements.txt"

# Installing dependencies at build time
RUN pip install $K_DIFFUSION_PACKAGE
RUN pip install $GFPGAN_PACKAGE
RUN git clone $CODEFORMER_REPO codeformer \
 && cd codeformer && git checkout $CODEFORMER_COMMIT_HASH && cd .. \
 && pip install -r codeformer/requirements.txt \
 && rm -r codeformer
COPY ./$REQS_FILE /sd
RUN pip install -r $REQS_FILE

COPY . /sd

ENTRYPOINT ["/bin/bash", "entrypoint.sh"]