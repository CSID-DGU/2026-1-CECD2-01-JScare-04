NEGATIVE_PATTERNS = [
    "없습니다",
    "없어요",
    "아닙니다",
    "없음"
]


def analyze_context(text: str) -> dict:

    negative = any(word in text for word in NEGATIVE_PATTERNS)

    return {
        "text": text,
        "negative": negative
    }