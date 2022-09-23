FROM docker.io/rocm/pytorch:rocm5.2.3_ubuntu20.04_py3.7_pytorch_1.12.1

COPY . /root/stable-diffusion

WORKDIR /root/stable-diffusion

# Update system
RUN apt update && apt -y upgrade

ENV PYTHONUNBUFFERED=1
ENV GRADIO_SERVER_NAME=0.0.0.0
ENV GRADIO_SERVER_PORT=7860
EXPOSE 7860

RUN rm -rf /root/stable-diffusion/models \
 && rm -rf /root/stable-diffusion/outputs \
 && ln -s /models /root/stable-diffusion \
 && ln -s /outputs /root/stable-diffusion

ENTRYPOINT ["/bin/bash", "entrypoint.sh"]