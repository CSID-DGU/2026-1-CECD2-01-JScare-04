<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*, java.net.*, com.emrDAO.MessageDAO" %> 

<%
    request.setCharacterEncoding("UTF-8");
    String userMessage = request.getParameter("message");
    
    // 1. 현재 사용자 ID 가져오기
    String userId = (String) session.getAttribute("Id");
    if(userId == null) userId = "GUEST"; // 비로그인 시 예외처리

    // 2. [DB 저장] 사용자의 질문 저장 ("USER")
    MessageDAO msgDao = MessageDAO.getInstance();
    msgDao.insertChatLog(userId, userMessage, "USER");

    // --- (파이썬 서버 통신 코드) ---
    String cleanMessage = userMessage.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n");
    String jsonInputString = "{\"message\": \"" + cleanMessage + "\"}";
    String targetUrl = "http://localhost:5000/chat";
    
    HttpURLConnection conn = null;
    BufferedReader br = null;
    StringBuilder responseSb = new StringBuilder();

    try {
        URL url = new URL(targetUrl);
        conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
        conn.setDoOutput(true);

        try (OutputStream os = conn.getOutputStream()) {
            byte[] input = jsonInputString.getBytes("UTF-8");
            os.write(input, 0, input.length);
        }

        br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
        String line;
        while ((line = br.readLine()) != null) {
            responseSb.append(line);
        }
    } catch (Exception e) {
        responseSb.append("{\"response\": \"AI 서버 연결 실패\"}");
    }
    // ----------------------------

    // 3. [DB 저장] AI의 답변 저장 ("BOT")
    String botJson = responseSb.toString();
    String botContent = "응답 없음";

    // JSON 파싱 (간이) - {"response": "내용"} 에서 내용 추출
    if(botJson.contains("\"response\":")) {
        try {
            int start = botJson.indexOf("\"response\":") + 11; // "response": 뒤부터
            // 뒤에 있는 따옴표 위치 찾기 (단, JSON 형식에 따라 유동적일 수 있음)
            int firstQuote = botJson.indexOf("\"", start);
            int lastQuote = botJson.lastIndexOf("\"");
            
            // 단순하게 전체 JSON에서 텍스트만 발라내기보단, 통째로 넣거나
            // 파이썬이 보내준 순수 텍스트만 추출하는 게 좋습니다.
            // 여기선 에러 방지를 위해 간단히 처리합니다.
            botContent = botJson.substring(firstQuote + 1, lastQuote);
        } catch(Exception e) {
            botContent = botJson; // 파싱 실패 시 전체 저장
        }
    }
    
    // AI 답변을 DB에 저장
    msgDao.insertChatLog(userId, botContent, "BOT");

    out.clear();
    out.print(responseSb.toString());
%>