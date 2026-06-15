# EMR Project

JSP/Servlet 기반 EMR 웹 애플리케이션입니다. 원본 `EMR-Project.war`를 압축 해제한 뒤 GitHub 업로드용으로 소스 중심으로 정리했습니다.

## 구성

- `*.jsp`: 화면 및 AJAX 엔드포인트
- `CSS/`, `js/`: 정적 리소스
- `WEB-INF/classes/com/emrBean`: Java Bean
- `WEB-INF/classes/com/emrDAO`: DB 접근 클래스
- `db/schema.sql`: MySQL `bitcare` 스키마 DDL

## 실행 환경

- Java servlet container, 예: Apache Tomcat
- MySQL
- MySQL JDBC driver
- JSTL runtime

원본 WAR에 포함되어 있던 `.class`, `.jar`, 백업 폴더는 저장소에서 제외했습니다.

## DB 설정

DB 접속 정보는 환경변수로 설정합니다.

```bash
DB_URL=jdbc:mysql://localhost:3306/bitcare?serverTimezone=Asia/Seoul
DB_USER=dbtest
DB_PASSWORD=your_password
```

예시는 `.env.example`에 있습니다.

## 데이터베이스 생성

```sql
SOURCE db/schema.sql;
```

또는 DBeaver/MySQL Workbench에서 `db/schema.sql`을 열어 실행합니다.

## 참고

일부 JSP/Java 주석은 원본 WAR 생성 과정에서 인코딩이 깨진 상태로 포함되어 있을 수 있습니다. DDL 파일은 UTF-8 기준으로 정리했습니다.
