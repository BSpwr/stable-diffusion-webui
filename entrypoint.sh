#!/bin/bash

echo "Testing internet connection ..."
PING_CMD="curl github.com > /dev/null 2>&1"
eval $PING_CMD
if [[ $? -eq 0 ]]; then
    echo "Already connected."
else
    echo -n "Waiting for connection..."
    while true; do
        eval $PING_CMD
        if [[ $? -eq 0 ]]; then
            echo
            echo "Connected."
            break
        else
            sleep 0.5
            echo -n .
        fi
    done
fi

export PYTORCH_HIP_ALLOC_CONF=max_split_size_mb:128 # Limit pytorch memory fragmentation
export HSA_OVERRIDE_GFX_VERSION=10.3.0 # Set necessary export for Stable Diffusion to work on RDNA 5700XT using ROCm
export TORCH_COMMAND='pip install torch torchvision --extra-index-url https://download.pytorch.org/whl/rocm5.1.1'
export REQS_FILE='requirements.txt'
python launch.py --precision full --no-half --max-batch-count 32 --medvram