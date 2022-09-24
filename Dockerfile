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
 && ln -s /outputs /sd

COPY . /sd

ENTRYPOINT ["/bin/bash", "entrypoint.sh"]