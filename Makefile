include .env
eupload-dataset:
	python upload_dataset.py --dataset_path $(OUTPUT_NAME) --repo_name $(HF_REPO_NAME) --token $(HF_TOKEN)ort $(shell sed 's/=.*//' .env)

.PHONY: help create-dataset upload-dataset clean

help:
	@echo "Available commands:"
	@echo "  create-dataset  - Create HF dataset from directory tree"
	@echo "  upload-dataset  - Upload dataset to Hugging Face Hub"
	@echo "  clean          - Remove local dataset files"

create-dataset:
	uv run make_hf_dataset.py --data_path $(DATA_PATH) --output_name $(OUTPUT_NAME)

upload-dataset:
	uv run upload_dataset_to_hf_hub.py --dataset_path $(OUTPUT_NAME) --repo_name $(HF_REPO_NAME) --token $(HF_TOKEN)

clean:
	rm -rf $(OUTPUT_NAME)
