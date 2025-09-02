#!/bin/bash

cd /home/euler/Projects/Forks/lmms-eval

if [ -d ".venv" ]; then
    source .venv/bin/activate
fi

if [ -f ".env" ]; then
    export $(grep -v '^#' .env | xargs)
fi

if [ -z "$OPENROUTER_API_KEY" ]; then
    echo "Error: OPENROUTER_API_KEY environment variable is not set!"
    echo "Please add OPENROUTER_API_KEY=your-key to your .env file"
    exit 1
fi

export OPENAI_API_KEY="$OPENROUTER_API_KEY"
export OPENAI_API_BASE="https://openrouter.ai/api/v1"

# Set default model if not specified
MODEL=${OPENROUTER_MODEL:-"gpt-4o"}

echo "Using OpenRouter with model: $MODEL"
echo "API Base: $OPENAI_API_BASE"
echo "Running rock classification evaluation..."

uv run lmms_eval \
    --model openai_compatible \
    --model_args model_version="$MODEL" \
    --tasks rock_classification \
    --batch_size 1 \
    --log_samples \
    --limit 32 \
    --log_samples_suffix "rock-classification-openrouter-$(echo $MODEL | tr '/' '-')" \
    --output_path "./logs/rock_classification_openrouter/"

echo "Evaluation completed! Check results in ./logs/rock_classification_openrouter/"
echo "Model used: $MODEL"
