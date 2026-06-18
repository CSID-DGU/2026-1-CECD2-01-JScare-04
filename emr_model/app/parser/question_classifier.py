from rapidfuzz import fuzz


QUESTION_PATTERNS = {
    "chief_complaint": [
        "어디가 불편하세요",
        "어떤 증상이 있으신가요"
    ],

    "present_illness": [
        "언제부터 증상이 있었나요",
        "증상이 얼마나 지속됐나요"
    ],

    "past_history": [
        "과거에 진단받은 질환이 있으신가요",
        "기저질환이 있으신가요"
    ],

    "plan": [
        "현재 복용 중인 약이 있으신가요"
    ],

    "diagnosis": [
        "진단 결과를 말씀드리겠습니다"
    ]
}


def classify_question(text: str) -> str | None:

    best_field = None
    best_score = 0

    for field, patterns in QUESTION_PATTERNS.items():

        for pattern in patterns:

            score = fuzz.partial_ratio(text, pattern)

            if score > best_score:
                best_score = score
                best_field = field

    return best_field if best_score >= 70 else None