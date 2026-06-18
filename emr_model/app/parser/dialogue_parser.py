import re


def parse_transcript(transcript: str) -> list[str]:

    transcript = transcript.replace("\r\n", "\n")

    lines = [
        re.sub(r"\s+", " ", line).strip()
        for line in transcript.split("\n")
    ]

    return [line for line in lines if line]