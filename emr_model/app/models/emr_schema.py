from pydantic import BaseModel


class TranscriptRequest(BaseModel):
    transcript: str


class EMRResponse(BaseModel):
    status: str
    emr: dict
    extracted_data: list