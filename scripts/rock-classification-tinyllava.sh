#!/bin/bash

# Make sure we're in the right directory
cd /home/euler/Projects/Forks/lmms-eval

# Activate environment (if using UV)
if [ -d ".venv" ]; then
    source .venv/bin/activate
fi

# Install TinyLLaVA if not already installed
if [ ! -d "../TinyLLaVA_Factory" ]; then
    echo "Installing TinyLLaVA..."
    cd ..
    git clone https://github.com/TinyLLaVA/TinyLLaVA_Factory
    cd TinyLLaVA_Factory

    pip install --no-deps -U .

    pip install torch==2.0.1 torchvision==0.15.2 --index-url https://download.pytorch.org/whl/cu118

    if [ -f "tinyllava_repr_requirements.txt" ]; then
        pip install -r tinyllava_repr_requirements.txt
    fi

    cd ../lmms-eval
fi

# Clean up GPU memory first
echo "Cleaning GPU memory..."
python -c "import torch; torch.cuda.empty_cache()" 2>/dev/null || true

# Run rock classification evaluation with TinyLLaVA
echo "Running rock classification evaluation..."
uv run lmms_eval \
    --model tinyllava \
    --model_args pretrained=tinyllava/TinyLLaVA-Phi-2-SigLIP-3.1B,conv_mode=phi \
    --tasks rock_classification \
    --batch_size 1 \
    --log_samples \
    --log_samples_suffix rock-classification-tinyllava \
    --output_path ./logs/rock_classification/

echo "Evaluation completed! Check results in ./logs/rock_classification/"