# Simple Rock Classification with lmms-eval

## Goal

Evaluate rock/mineral classification using lightweight vision-language models with exact_match and ANLS metrics.

## Quick Setup

### 1. Install lmms-eval

```bash
git clone https://github.com/EvolvingLMMs-Lab/lmms-eval.git
cd lmms-eval
uv venv dev
source dev/bin/activate
uv pip install -e .
```

### 2. Prepare Dataset

Create HuggingFace dataset from your ImageClassificationDirectoryTree:

- **Dataset Path**: `/data/ml-rocks-datasets/dataset_splited/test`
- **Classes**: ~300+ rock types (rhodonite, fuchsite, etc.)

### 3. Create Task Files

**File**: `lmms_eval/tasks/rock_classification/rock_classification.yaml`

```yaml
dataset_path: rock_dataset # Your HF dataset name
task: "rock_classification"
test_split: test
output_type: generate_until
doc_to_visual: !function utils.rock_doc_to_visual
doc_to_text: !function utils.rock_doc_to_text
doc_to_target: "label"
generation_kwargs:
  max_new_tokens: 32
  temperature: 0
  do_sample: false
metric_list:
  - metric: exact_match
    aggregation: mean
    higher_is_better: true
  - metric: anls
    aggregation: mean
    higher_is_better: true
metadata:
  version: 1.0
```

**File**: `lmms_eval/tasks/rock_classification/utils.py`

```python
def rock_doc_to_visual(doc):
    return doc["image"]

def rock_doc_to_text(doc):
    return "What type of rock or mineral is shown in this image? Answer with the exact name."

def rock_doc_to_target(doc):
    return doc["label"]
```

### 4. Convert Your Dataset

Create script to convert ImageClassificationDirectoryTree to HuggingFace format:

- Scan `/data/ml-rocks-datasets/dataset_splited/test/`
- Create image-label pairs
- Upload to HF Hub or use locally

### 5. Run Evaluation

```bash
# Test with lightweight model first
python -m lmms_eval --model llava --model_args pretrained="llava-hf/llava-1.5-7b-hf" --tasks rock_classification --batch_size 1
```

## Implementation Steps

1. [✅] Install lmms-eval
2. [✅] Create dataset conversion script
3. [✅] Create task YAML and utils.py
4. [ ] Test with TinyLLaVA-Phi-2-SigLIP-3.1B
5. [ ] Run evaluation and analyze results

## Models to Test (starting lightweight)

- TinyLLaVA-Phi-2-SigLIP-3.1B (start here)
- InstructBLIP-7B
- Qwen-VL-7B
- MiniCPM-V

## Expected Output

- exact_match: Percentage of perfectly matched rock names
- anls: Average normalized Levenshtein similarity (handles typos)

This simple setup gets you running quickly with the core functionality you need.
