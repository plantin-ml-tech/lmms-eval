#!/bin/bash

cd /home/euler/Projects/Forks/lmms-eval

if [ -d ".venv" ]; then
    source .venv/bin/activate
fi

if [ -f ".env" ]; then
    export $(grep -v '^#' .env | xargs)
fi

if [ -z "$OPENAI_API_KEY" ]; then
    echo "Error: OPENAI_API_KEY environment variable is not set!"
    echo "Please add OPENAI_API_KEY=your-api-key to your .env file"
    exit 1
fi

export API_TYPE="openai"
export OPENAI_API_URL="https://api.openai.com/v1/chat/completions"

echo "Preparing for GPT-4V evaluation..."

echo "Running rock classification evaluation with GPT-4V..."
uv run lmms_eval \
    --model gpt4v \
    --model_args model_version=gpt-4o,modality=image,max_frames_num=1 \
    --tasks rock_classification \
    --batch_size 1 \
    --log_samples \
    --limit 32 \
    --log_samples_suffix rock-classification-gpt4v \
    --output_path ./logs/rock_classification_gpt4v/

echo "Evaluation completed! Check results in ./logs/rock_classification_gpt4v/"
echo "Note: This uses OpenAI API and will incur costs based on your usage."
