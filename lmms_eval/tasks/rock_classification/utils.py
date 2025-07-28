def rock_doc_to_visual(doc):
    return doc["image"]


def rock_doc_to_text(doc):
    return "What type of rock or mineral is shown in this image? Answer with SINGLE word - the exact name."


def rock_doc_to_target(doc):
    return doc["label"]
