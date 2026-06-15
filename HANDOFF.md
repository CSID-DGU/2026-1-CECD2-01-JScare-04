# EMR Project Handoff

이 문서는 다른 PC/Codex 세션에서 바로 이어서 작업할 수 있도록 현재까지 진행한 내용을 정리한 것입니다.

## Repository

- GitHub: https://github.com/Dobby445/emr-project-private
- Visibility: private
- Local path on this PC: `C:\Users\c\Documents\EMR 프로젝트\EMR-Project-github`
- Branch: `master`

## Original Source

- 원본 WAR: `C:\Users\c\Desktop\EMR-Project.war`
- 압축 해제 폴더: `C:\Users\c\Documents\EMR 프로젝트\EMR-Project_extracted`
- GitHub 업로드용 정리 폴더: `C:\Users\c\Documents\EMR 프로젝트\EMR-Project-github`

## What Was Done

1. WAR 파일을 압축 해제하고 JSP/Java 소스 구조를 확인했다.
2. GitHub 업로드용 프로젝트 폴더를 새로 만들었다.
3. `.class`, `.jar`, `.war`, `Backup` 폴더는 저장소에서 제외했다.
4. `.gitignore`, `.env.example`, `README.md`를 추가했다.
5. DB 접속 하드코딩을 줄이기 위해 `DbConfig.java`를 추가했다.
6. `index.jsp`를 추가해서 `/EMR-Project/` 접속 시 `Login_Doctor.jsp`로 이동하게 했다.
7. `Doctor.jsp`의 입력 필드와 DB 저장 필드가 맞지 않던 문제를 정리했다.
8. `history` 테이블을 EMR 기록 저장 기준으로 확장했다.
9. GitHub private repo에 push했다.
10. Tomcat 9에 로컬 배포해서 로그인 페이지가 뜨는 것까지 확인했다.

## Important Commits

- `488375a Prepare EMR project for GitHub`
- `e5dbe8d Add login redirect index page`
- `8ef5809 Align doctor EMR fields with history data`

## Current App Entry

Tomcat 배포 후 시작 URL:

```text
http://localhost:8080/EMR-Project/
```

`index.jsp`가 아래로 리다이렉트한다.

```text
http://localhost:8080/EMR-Project/Login_Doctor.jsp
```

로그인 흐름:

```text
Login_Doctor.jsp -> loginprocess.jsp -> main.jsp
```

## DB Configuration

앱은 환경변수에서 DB 설정을 읽는다.

```text
DB_URL=jdbc:mysql://localhost:3306/bitcare?serverTimezone=Asia/Seoul
DB_USER=dbtest
DB_PASSWORD=change_me
```

관련 파일:

- `WEB-INF/classes/com/emrDAO/DbConfig.java`
- `.env.example`

## Database Files

전체 DDL:

```text
db/schema.sql
```

기존 DB에 EMR 필드 추가용 migration:

```text
db/migrations/001_extend_history_for_emr.sql
```

기존 `bitcare` DB가 이미 있으면 migration을 실행해야 한다.

```sql
SOURCE db/migrations/001_extend_history_for_emr.sql;
```

## EMR Field Alignment

`Doctor.jsp`에서 받는 EMR 입력 필드를 `history` 테이블에 저장하도록 맞췄다.

화면 입력 필드:

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

수정된 주요 파일:

- `Doctor.jsp`
- `ajax/saveDiagnosis.jsp`
- `WEB-INF/classes/com/emrBean/HistoryBean.java`
- `WEB-INF/classes/com/emrDAO/HistoryDAO.java`
- `db/schema.sql`
- `db/migrations/001_extend_history_for_emr.sql`

호환을 위해 기존 컬럼도 유지했다.

- `symptom_detail`은 `chief_complaint`와 같은 값으로 저장
- `memo`는 `plan`과 같은 값으로 저장

## Local Tomcat Test Result

이 PC에는 Tomcat 9가 있었다.

```text
C:\Program Files\Apache Software Foundation\Tomcat 9.0
```

테스트 결과:

- Tomcat started on port `8080`
- `/EMR-Project/` returned redirect
- `/EMR-Project/Login_Doctor.jsp` returned `200 OK`
- Login submit failed with `500 Internal Server Error`

500 원인:

```text
Communications link failure
The driver has not received any packets from the server.
```

즉, 이 PC에는 MySQL이 없거나 실행 중이 아니었다.

확인 결과:

- MySQL/MariaDB Windows service 없음
- `mysql`, `mysqld`, `mysqladmin` command 없음
- `localhost:3306` 포트 닫힘

## Java/Tomcat Note

처음에 JDK 25로 컴파일하면 Tomcat 런타임과 맞지 않아 아래 오류가 났다.

```text
UnsupportedClassVersionError
class file version 69.0
this version of the Java Runtime only recognizes class file versions up to 66.0
```

Tomcat 쪽 Java가 class version 66까지 인식하므로, 실행용 컴파일은 이렇게 했다.

```powershell
javac --release 22 -encoding UTF-8 WEB-INF\classes\com\emrBean\*.java WEB-INF\classes\com\emrDAO\*.java
```

Git에는 `.class` 파일을 커밋하지 않는다.

## Runtime Libraries

GitHub에는 JAR 파일을 올리지 않았다. 실행할 때는 `WEB-INF/lib`에 아래 JAR들이 필요하다.

- `mysql-connector-j-9.1.0.jar`
- `jstl.jar`
- `standard.jar`

원본 WAR 압축 해제본에는 있었다.

```text
EMR-Project_extracted/WEB-INF/lib
```

## Next Steps On The Other PC

1. GitHub private repo clone

```powershell
git clone https://github.com/Dobby445/emr-project-private.git
```

2. MySQL에 `bitcare` DB 준비

```sql
SOURCE db/schema.sql;
```

또는 기존 DB가 있으면:

```sql
SOURCE db/migrations/001_extend_history_for_emr.sql;
```

3. DB 계정 준비

```sql
CREATE USER 'dbtest'@'localhost' IDENTIFIED BY 'your_password';
GRANT ALL PRIVILEGES ON bitcare.* TO 'dbtest'@'localhost';
FLUSH PRIVILEGES;
```

4. 환경변수 설정

```powershell
setx DB_URL "jdbc:mysql://localhost:3306/bitcare?serverTimezone=Asia/Seoul"
setx DB_USER "dbtest"
setx DB_PASSWORD "your_password"
```

5. JAR 파일을 `WEB-INF/lib`에 넣기

6. Java class 컴파일

```powershell
javac --release 22 -encoding UTF-8 WEB-INF\classes\com\emrBean\*.java WEB-INF\classes\com\emrDAO\*.java
```

7. Tomcat `webapps/EMR-Project`로 배포

8. 접속

```text
http://localhost:8080/EMR-Project/
```

## Known Risks / TODO

- 로그인 로직은 아직 `select * from employee` 후 Java에서 비교한다. `WHERE id = ?` 방식으로 바꾸는 것이 좋다.
- 비밀번호는 평문 저장 구조다. 해시 저장으로 바꾸는 것이 좋다.
- DAO들이 singleton connection을 오래 들고 있어 DB 재시작 후 끊길 수 있다. 요청마다 connection을 열고 닫는 구조가 더 안전하다.
- 일부 JSP/Java 주석은 원본 WAR에서 인코딩이 깨져 있었다.
- AI 요약/챗봇은 `localhost:5000` 서버가 따로 필요하다.
