<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*, java.net.*" %>

<%
    request.setCharacterEncoding("UTF-8");
    
    // 1. 프론트엔드(Doctor.jsp)에서 보낸 통짜 JSON 문자열 받기
    String jsonInputString = request.getParameter("jsonData");

    // 데이터가 없으면 빈 JSON 객체 전송 방지
    if(jsonInputString == null || jsonInputString.trim().isEmpty()) {
        out.print("{\"error\": \"데이터가 없습니다.\"}");
        return;
    }

    // 2. 파이썬 FastAPI 서버 주소 (main.py 실행 포트 확인: 5000)
    String targetUrl = "http://localhost:5000/summarize"; 
    
    HttpURLConnection conn = null;
    BufferedReader br = null;
    StringBuilder responseSb = new StringBuilder();

    try {
        URL url = new URL(targetUrl);
        conn = (HttpURLConnection) url.openConnection();
        
        // 헤더 설정
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
        conn.setRequestProperty("Accept", "application/json");
        conn.setDoOutput(true);

        // 3. 파이썬으로 데이터 전송
        try(OutputStream os = conn.getOutputStream()) {
            byte[] input = jsonInputString.getBytes("UTF-8");
            os.write(input, 0, input.length);
        }

        // 4. 응답 받기
        int status = conn.getResponseCode();
        InputStream is = (status >= 200 && status < 300) ? conn.getInputStream() : conn.getErrorStream();
        
        br = new BufferedReader(new InputStreamReader(is, "UTF-8"));
        String line;
        while ((line = br.readLine()) != null) {
            responseSb.append(line);
        }

    } catch (Exception e) {
        responseSb.setLength(0);
        responseSb.append("{\"success\": false, \"message\": \"Java Server Error: " + e.getMessage() + "\"}");
    } finally {
        if(br != null) try { br.close(); } catch(Exception e){}
        if(conn != null) conn.disconnect();
    }

    // 5. 결과 반환
    out.clear();
    out.print(responseSb.toString());
%>