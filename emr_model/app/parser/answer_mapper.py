from app.parser.question_classifier import classify_question


def map_answers(lines: list[str]) -> list[dict]:

    results = []

    current_field = None
    current_answers = []

    for line in lines:

        field = classify_question(line)

        if field:

            if current_field and current_answers:
                results.append({
                    "field": current_field,
                    "answer": " ".join(current_answers)
                })

            current_field = field
            current_answers = []

        elif current_field:
            current_answers.append(line)

    if current_field and current_answers:
        results.append({
            "field": current_field,
            "answer": " ".join(current_answers)
        })

    return results