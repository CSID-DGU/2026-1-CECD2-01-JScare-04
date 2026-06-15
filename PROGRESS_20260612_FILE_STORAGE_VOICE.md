# Progress Update: EMR File Storage and Voice Draft

이 문서는 `PROJECT_STATUS.md` 작성 이후 추가로 진행한 작업만 정리한 기록입니다.

## Summary

- EMR 본문 데이터를 DB longtext에 계속 저장하지 않고 파일 스토리지에 저장하도록 변경했습니다.
- 저장 파일은 환자 ID 폴더 안에 `yyyyMMdd + 환자ID + 3자리번호` 규칙으로 생성됩니다.
- EMR 저장 시 JSON, Markdown, TXT 세 가지 파일을 함께 생성합니다.
- DB에는 EMR 본문 대신 파일 경로와 진료 메타데이터를 저장합니다.
- vitals는 환자 테이블에도 최신값으로 저장되도록 변경했습니다.
- `AI 요약` 버튼을 `음성 작성` 버튼으로 바꾸고, 브라우저 음성 인식 기반 초안 저장 기능을 추가했습니다.
- 음성 작성은 사용자가 `음성 진단 종료` 또는 `종료`라고 말할 때까지 계속 듣고, 종료 시 `VoiceEMR.json`으로 저장합니다.

## Storage Rule

기본 저장 위치는 Tomcat 기준입니다.

```text
C:\Program Files\Apache Software Foundation\Tomcat 9.0\emr-storage
```

환경변수 `EMR_STORAGE_DIR`이 있으면 해당 경로를 우선 사용합니다.

일반 EMR 기록 파일:

```text
emr-storage/patients/{patient_id}/{yyyyMMdd}{patient_id}{seq}.json
emr-storage/patients/{patient_id}/{yyyyMMdd}{patient_id}{seq}.md
emr-storage/patients/{patient_id}/{yyyyMMdd}{patient_id}{seq}.txt
```

예시:

```text
emr-storage/patients/P202606001/20260612P202606001001.json
emr-storage/patients/P202606001/20260612P202606001001.md
emr-storage/patients/P202606001/20260612P202606001001.txt
```

음성 EMR 초안:

```text
emr-storage/patients/{patient_id}/VoiceEMR.json
```

## VoiceEMR Format

`VoiceEMR.json`은 아직 AI 요약을 실행하지 않고, 나중에 요약 AI에 넘길 준비 데이터로만 저장합니다.

```json
{
  "patient_id": "P202606001",
  "created_at": "2026-06-12T11:03:01.2794049",
  "ready_for_summary": true,
  "source": "browser_speech_recognition",
  "transcript": "음성으로 작성된 원문 텍스트"
}
```

## Changed Files

- `Doctor.jsp`
  - `AI 요약` 흐름을 `음성 작성` 흐름으로 변경했습니다.
  - Web Speech API의 `SpeechRecognition` / `webkitSpeechRecognition`을 사용합니다.
  - `continuous = true`로 설정해 짧게 끝나지 않도록 했습니다.
  - `"음성 진단 종료"` 또는 `"종료"`가 인식되면 녹취를 멈추고 `ajax/saveVoiceEmr.jsp`로 텍스트를 전송합니다.

- `ajax/saveVoiceEmr.jsp`
  - 음성 인식 결과 텍스트를 받아 `VoiceEMR.json`으로 저장합니다.
  - 응답에는 `patients/{patient_id}/VoiceEMR.json` 형식의 상대 경로를 반환합니다.

- `WEB-INF/classes/com/emrDAO/EmrRecordStorage.java`
  - EMR 기록 파일 저장/읽기 전담 클래스를 추가했습니다.
  - JSON, Markdown, TXT 파일 생성과 저장 경로 계산을 담당합니다.
  - `VoiceEMR.json` 저장도 담당합니다.

- `WEB-INF/classes/com/emrDAO/HistoryDAO.java`
  - 신규/수정 진료 기록 저장 전에 `EmrRecordStorage.save()`를 호출합니다.
  - DB에는 대용량 본문 대신 `emr_json_path`, `emr_md_path`, `emr_txt_path`를 저장합니다.
  - 과거 기록 조회 시 JSON 파일을 읽어 EMR 본문을 다시 채웁니다.

- `WEB-INF/classes/com/emrBean/HistoryBean.java`
  - EMR 파일 경로 필드 3개를 추가했습니다.

- `WEB-INF/classes/com/emrDAO/PatientDAO.java`
  - 최신 vitals를 환자 테이블에 저장하는 `updateVitals()`를 추가했습니다.

- `ajax/saveDiagnosis.jsp`
  - 진료 기록 저장 성공 시 환자 vitals 최신값을 갱신합니다.

- `db/migrations/005_file_storage_and_patient_vitals.sql`
  - `history`에 EMR 파일 경로 컬럼을 추가합니다.
  - `patient`에 vitals 컬럼과 `vitals_updated_at`을 추가합니다.

- `db/schema.sql`
  - 신규 컬럼 구조를 반영했습니다.

## Database Changes

추가된 `history` 컬럼:

```sql
emr_json_path varchar(255)
emr_md_path varchar(255)
emr_txt_path varchar(255)
```

추가된 `patient` 컬럼:

```sql
height float
weight float
bp_systolic int
bp_diastolic int
temp float
hr varchar(10)
rr varchar(10)
spo2 varchar(10)
vitals_updated_at timestamp
```

로컬 MySQL에는 migration 005 적용을 확인했습니다.

## Verification

다음 검증을 완료했습니다.

- Java 컴파일 성공
- Tomcat 배포 폴더에 수정 파일 반영
- Tomcat 재기동 후 `Doctor.jsp` HTTP 200 확인
- EMR 저장 테스트 성공
- 저장된 DB의 EMR 본문 컬럼이 `NULL`이고 파일 경로만 남는 것 확인
- 저장 파일 경로가 `patients/PTEST0005/20260612PTEST0005001.json` 형식으로 생성되는 것 확인
- 환자 테이블에 vitals 최신값이 저장되는 것 확인
- `ajax/saveVoiceEmr.jsp` 호출 시 `patients/PTESTVOICE/VoiceEMR.json` 응답 확인
- 테스트용 DB 행과 테스트 저장 폴더는 정리 완료

## Notes

- 음성 인식은 서버 AI가 아니라 브라우저의 Web Speech API를 사용합니다.
- 서버로 음성 파일을 업로드하지 않습니다.
- 브라우저가 음성을 텍스트로 변환한 뒤, 텍스트만 서버에 보내 JSON으로 저장합니다.
- 실제 AI 요약 기능은 아직 연결하지 않았습니다.
- `VoiceEMR.json`의 `ready_for_summary: true` 값은 이후 요약 AI가 처리 대상을 찾기 쉽게 하기 위한 준비 값입니다.
