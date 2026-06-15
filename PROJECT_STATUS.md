# EMR Project Status

이 문서는 현재 PC에서 EMR 프로젝트에 적용한 작업 내역과 실행 상태를 정리한 최신 인수인계 문서입니다.

## Repository

- GitHub: https://github.com/Dobby445/emr-project-private
- Branch: `master`
- Local path: `C:\Users\c\Documents\EMR 프로젝트\EMR-Project-github`
- Tomcat deploy path: `C:\Program Files\Apache Software Foundation\Tomcat 9.0\webapps\EMR-Project`

## Current Runtime

- Tomcat: Apache Tomcat 9
- App URL: `http://localhost:8080/EMR-Project/`
- Login URL: `http://localhost:8080/EMR-Project/Login_Doctor.jsp`
- MySQL service: `MySQL80`
- MySQL port: `3306`
- Database: `bitcare`

## DB Login

App environment variables:

```text
DB_URL=jdbc:mysql://localhost:3306/bitcare?serverTimezone=Asia/Seoul
DB_USER=dbtest
DB_PASSWORD=<set locally>
```

MySQL root password used locally:

```text
root / <set locally>
```

Test login account:

```text
ID: admin
PW: <set locally>
role: DOCTOR
dept_id: 01
```

## What Was Done

### 1. WAR 정리 및 GitHub 업로드

- 원본 WAR: `C:\Users\c\Desktop\EMR-Project.war`
- 압축 해제: `EMR-Project_extracted`
- GitHub용 정리 폴더: `EMR-Project-github`
- `.class`, `.jar`, `.war`, `Backup`은 Git에서 제외
- `README.md`, `.gitignore`, `.env.example`, `HANDOFF.md` 추가
- private GitHub repo 생성 및 push 완료

### 2. 기본 실행 진입점 추가

- `index.jsp` 추가
- `/EMR-Project/` 접속 시 `Login_Doctor.jsp`로 redirect

### 3. DB 연결 정리

- `DbConfig.java` 추가
- DAO의 하드코딩 DB 접속 정보를 환경변수 기반으로 변경
- 기본 DB는 `bitcare`

### 4. MySQL 세팅

- MySQL PATH 등록
- `bitcare` DB 생성
- 18개 테이블 생성
- `dbtest` 계정 생성
- Tomcat 앱 DB 연결 확인

### 5. 회원가입 수정

- 기존 `employee.id varchar(10)` 때문에 긴 아이디 가입 시 오류 발생
- `employee.id` 및 관련 FK 컬럼을 `varchar(50)`으로 확장
- migration: `db/migrations/002_extend_employee_ids.sql`
- `join.jsp` 아이디 입력에 `maxlength="50"` 추가

### 6. 의료과 선택 추가

- 회원가입 화면에 의료과 드롭다운 추가
- `dept` 테이블에서 의료과 목록 조회
- 회원가입 시 `employee.dept_id` 저장
- 회원가입 시 `role=DOCTOR` 저장
- `MemberBean`, `MemberDAO`, `joinProcess.jsp`, `join.jsp` 수정
- migration: `db/migrations/003_seed_departments.sql`
- 한글 의료과명이 `??`로 깨지는 문제 수정
- 의료과 seed를 UTF-8 HEX 방식으로 변경

### 7. 환자 ID 자동 생성 규칙 변경

신규 환자 등록 시 기존 UUID 대신 아래 규칙 사용:

```text
P + yyyy + MM + 월별순번3자리
```

예:

```text
P202606001
P202606002
```

수정 파일:

- `PatientDAO.java`
- `registerProcess.jsp`

테스트 결과:

```json
"generatedId": "P202606001"
```

테스트 환자는 삭제 완료.

### 8. Doctor.jsp EMR 필드 통일

`Doctor.jsp` 입력 필드와 DB 저장 필드를 EMR 기준으로 맞춤.

저장되는 EMR 필드:

- `chief_complaint`
- `present_illness`
- `past_history`
- `height`
- `weight`
- `bp_systolic`
- `bp_diastolic`
- `temp`
- `hr`
- `rr`
- `spo2`
- `lab_results`
- `imaging_results`
- `diagnosis`
- `plan`
- `free_text`

수정 파일:

- `Doctor.jsp`
- `ajax/saveDiagnosis.jsp`
- `HistoryBean.java`
- `HistoryDAO.java`
- `db/schema.sql`
- `db/migrations/001_extend_history_for_emr.sql`

호환용:

- `symptom_detail`에는 `chief_complaint` 저장
- `memo`에는 `plan` 저장

### 9. Doctor.jsp 진료 기록 작성 화면 재구성

진료 작성 화면을 EMR 차트 형태로 다시 구성.

구성:

- 진료 기본정보
- Vitals
- SOAP 차트
  - `S. Subjective`
  - `O. Objective`
  - `A/P. Assessment & Plan`
- AI 요약 영역
- 저장/초기화 버튼 영역

수정 파일:

- `Doctor.jsp`

### 10. 과거 진료 기록 작성/수정 시간 표시

요청:

- 과거 진료 기록에 원본 작성 시간과 수정 후 작성 시간을 표시

적용:

- `history.updated_at` 컬럼 추가
- 수정 시 `updated_at=NOW()` 저장
- 과거 진료 기록 카드에 표시
  - `작성: yyyy-MM-dd HH:mm`
  - `수정: yyyy-MM-dd HH:mm`
  - 수정 전이면 `수정: -`

수정 파일:

- `Doctor.jsp`
- `HistoryBean.java`
- `HistoryDAO.java`
- `db/schema.sql`
- `db/migrations/004_add_history_updated_at.sql`

현재 로컬 MySQL에는 migration 적용 완료.

커밋:

```text
f1db7bf Track history update timestamps
```

주의:

- 이 커밋은 로컬에는 완료됨.
- GitHub push는 Codex 사용량 제한 때문에 실패했음.
- 나중에 아래 명령 실행 필요:

```powershell
git push
```

## Migrations

현재 존재하는 migration:

```text
db/migrations/001_extend_history_for_emr.sql
db/migrations/002_extend_employee_ids.sql
db/migrations/003_seed_departments.sql
db/migrations/004_add_history_updated_at.sql
```

이미 현재 로컬 DB에는 모두 적용됨.

## Tomcat Notes

Tomcat 9가 Java 22 런타임을 사용 중이므로 컴파일 시 아래 옵션 사용:

```powershell
javac --release 22 -encoding UTF-8 WEB-INF\classes\com\emrBean\*.java WEB-INF\classes\com\emrDAO\*.java
```

Git에는 `.class` 파일을 커밋하지 않음.

## Current Git State Notes

최근 커밋:

```text
f1db7bf Track history update timestamps
```

이 커밋은 아직 원격 push가 안 됐을 수 있음. 확인:

```powershell
git status -sb
```

push:

```powershell
git push
```

## Known Issues / TODO

- 로그인 로직이 아직 `select * from employee` 후 Java에서 비교함. `WHERE id = ?`로 개선 필요.
- 비밀번호가 평문 저장됨. 해시 저장 필요.
- DAO singleton connection 구조라 DB 재시작 후 연결이 끊길 수 있음.
- AI 요약/챗봇은 별도 `localhost:5000` 서버 필요.
- 일부 원본 JSP/Java 주석은 WAR 단계에서 인코딩이 깨진 흔적이 있음.
