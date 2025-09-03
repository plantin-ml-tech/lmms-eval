import argparse
import os
from pathlib import Path

from dotenv import load_dotenv

from datasets import Dataset, Image

load_dotenv()


def create_dataset_from_tree(data_path, output_name, image_extensions=None):
    if image_extensions is None:
        image_extensions = ["*.jpg", "*.jpeg", "*.png", "*.bmp", "*.tiff"]

    data_path = Path(data_path)
    images = []
    labels = []

    for class_dir in data_path.iterdir():
        if not class_dir.is_dir():
            continue

        class_name = class_dir.name
        for ext in image_extensions:
            for img_file in class_dir.glob(ext):
                images.append(str(img_file))
                labels.append(class_name)

    dataset = Dataset.from_dict({"image": images, "label": labels}).cast_column(
        "image", Image()
    )

    dataset.save_to_disk(output_name)
    print(f"Created dataset '{output_name}' with {len(dataset)} samples")
    print(f"Classes: {len(set(labels))}")
    return dataset


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--data_path",
        default=os.getenv(
            "DATA_PATH", "/home/euler/Projects/Forks/rock-identifier/data/test-dataset"
        ),
    )
    parser.add_argument(
        "--output_name", default=os.getenv("OUTPUT_NAME", "rock-dataset-test")
    )
    args = parser.parse_args()

    create_dataset_from_tree(args.data_path, args.output_name)
