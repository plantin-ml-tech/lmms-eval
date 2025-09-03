include .env

.PHONY: help create-dataset upload-dataset create-and-upload clean

help:
	@echo "Available commands:"
	@echo "  create-dataset     - Create HF dataset from directory tree"
	@echo "  upload-dataset     - Upload dataset to Hugging Face Hub"
	@echo "  create-and-upload  - Create dataset and upload to HF Hub (single command)"
	@echo "  clean             - Remove local dataset files"

create-dataset:
	uv run make_hf_dataset.py --data_path "$(DATA_PATH)" --output_name "$(OUTPUT_NAME)"

upload-dataset:
	uv run upload_dataset_to_hf_hub.py --dataset_path "$(OUTPUT_NAME)" --repo_name "$(HF_REPO_NAME)" --token "$(HF_TOKEN)"

create-and-upload-dataset: create-dataset upload-dataset
	@echo "✅ Dataset created and uploaded successfully!"
	@echo "📊 Dataset available at: https://huggingface.co/datasets/$(HF_REPO_NAME)"

clean:
	rm -rf "$(OUTPUT_NAME)"
	@echo "🗑️ Cleaned local dataset files"
