import json
from pathlib import Path


BASE_DIR = Path(__file__).resolve().parent.parent

with open(BASE_DIR / "db" / "medical_terms.json", encoding="utf-8") as f:
    TERMS = json.load(f)


def extract_entities(text: str) -> list[dict]:

    entities = []

    for category, words in TERMS.items():

        for word in words:

            if word in text:

                entities.append({
                    "term": word,
                    "category": category
                })

    return entities