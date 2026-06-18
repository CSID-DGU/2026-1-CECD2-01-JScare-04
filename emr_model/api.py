from fastapi import APIRouter

from app.models.emr_schema import TranscriptRequest
from app.parser.dialogue_parser import parse_transcript
from app.parser.answer_mapper import map_answers
from app.emr.emr_generator import generate_emr
from app.nlp.learning_engine import save_learning_data


router = APIRouter()


@router.post("/process")
def process(data: TranscriptRequest):

    lines = parse_transcript(data.transcript)

    mapped = map_answers(lines)

    emr, extracted = generate_emr(mapped)

    save_learning_data(extracted)

    return {
        "status": "success",
        "emr": emr,
        "extracted_data": extracted
    }


@router.get("/health")
def health():

    return {"status": "ok"}