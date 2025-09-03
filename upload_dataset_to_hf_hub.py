from datasets import load_from_disk
import argparse
import os
from dotenv import load_dotenv

load_dotenv()


def upload_dataset_to_hub(local_dataset_path, repo_name, token=None):
    dataset = load_from_disk(local_dataset_path)

    dataset.push_to_hub(repo_name, token=token)
    print(f"Dataset uploaded to: https://huggingface.co/datasets/{repo_name}")


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--dataset_path", default=os.getenv("OUTPUT_NAME", "datasets/rock-dataset-test")
    )
    parser.add_argument(
        "--repo_name", default=os.getenv("HF_REPO_NAME", "DenysKovalML/rock-dataset-test")
    )
    parser.add_argument("--token", default=os.getenv("HF_TOKEN"))
    args = parser.parse_args()

    upload_dataset_to_hub(args.dataset_path, args.repo_name, args.token)
