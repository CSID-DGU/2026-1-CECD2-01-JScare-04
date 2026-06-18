from app.nlp.medical_entity_extractor import extract_entities
from app.nlp.context_analyzer import analyze_context


def generate_emr(mapped_answers: list):

    emr = {
        "chief_complaint": "",
        "present_illness": "",
        "past_history": "",
        "lab_results": "",
        "imaging_results": "",
        "diagnosis": "",
        "plan": "",
        "free_text": ""
    }

    extracted = []

    for item in mapped_answers:

        field = item["field"]
        answer = item["answer"]

        emr[field] = answer

        extracted.append({
            "field": field,
            "context": analyze_context(answer),
            "entities": extract_entities(answer)
        })

    return emr, extracted