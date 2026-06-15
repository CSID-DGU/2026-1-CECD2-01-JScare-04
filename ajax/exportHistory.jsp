<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, com.emrDAO.HistoryDAO, com.emrBean.HistoryBean" %>

<%
    request.setCharacterEncoding("UTF-8");
    
    // 파라미터로 기록 ID를 받음
    String historyId = request.getParameter("history_id");

    if (historyId == null || historyId.trim().isEmpty()) {
        response.sendError(400, "History ID is missing");
        return;
    }

    // 파일 다운로드 헤더 설정
    String fileName = "MedicalRecord_" + historyId + ".json";
    response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");

    HistoryDAO dao = HistoryDAO.getInstance();
    
    // [중요] 단건 조회 메서드가 필요합니다 (아래 3단계 참고)
    // 만약 단건 조회 메서드가 없다면, 전체 조회 후 ID로 필터링하는 방식 사용
    // 여기서는 getHistoryById(historyId)가 있다고 가정하거나, 직접 구현
    
    // (임시) 전체 조회 후 필터링 방식 (DAO 수정 없이 가능)
    // 실제로는 DAO에 getHistoryById() 만드는 게 정석입니다.
    
    HistoryBean target = dao.getHistoryById(historyId); // DAO에 메서드 추가 필요 (3단계)

    // JSON 생성
    StringBuilder json = new StringBuilder();
    json.append("["); // 배열 형태로 내보냄 (가져오기 로직 호환성 유지)
    
    if (target != null) {
        // 특수문자 처리
        String memo = (target.getMemo() == null) ? "" : target.getMemo().replace("\"", "\\\"").replace("\r\n", "\\n").replace("\n", "\\n");
        String symptom = (target.getSymptomDetail() == null) ? "" : target.getSymptomDetail().replace("\"", "\\\"").replace("\r\n", "\\n").replace("\n", "\\n");

        json.append("{");
        json.append("\"id\":\"" + target.getId() + "\",");
        json.append("\"patient_id\":\"" + target.getPatientId() + "\",");
        json.append("\"symptom_detail\":\"" + symptom + "\",");
        json.append("\"memo\":\"" + memo + "\",");
        json.append("\"bp_systolic\":\"" + target.getBpSystolic() + "\",");
        json.append("\"bp_diastolic\":\"" + target.getBpDiastolic() + "\",");
        json.append("\"temp\":\"" + target.getTemp() + "\",");
        json.append("\"weight\":\"" + target.getWeight() + "\",");
        json.append("\"height\":\"" + target.getHeight() + "\",");
        json.append("\"date\":\"" + target.getEntryDate() + "\"");
        json.append("}");
    }
    
    json.append("]");
    out.print(json.toString());
%>