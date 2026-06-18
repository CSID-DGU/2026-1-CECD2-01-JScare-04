import json
from pathlib import Path
from datetime import datetime


BASE_DIR = Path(__file__).resolve().parent.parent

LOG_FILE = BASE_DIR / "db" / "learning_log.json"


def save_learning_data(data: list):

    if LOG_FILE.exists():

        with open(LOG_FILE, encoding="utf-8") as f:
            logs = json.load(f)

    else:
        logs = []

    logs.append({
        "timestamp": datetime.now().isoformat(),
        "data": data
    })

    with open(LOG_FILE, "w", encoding="utf-8") as f:
        json.dump(logs, f, ensure_ascii=False, indent=2)