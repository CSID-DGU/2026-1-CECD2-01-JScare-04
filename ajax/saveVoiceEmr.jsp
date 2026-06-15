<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.nio.file.Path, com.emrDAO.EmrRecordStorage" %>

<%
    request.setCharacterEncoding("UTF-8");

    boolean success = false;
    String message = "";
    String path = "";

    try {
        String patientId = request.getParameter("patient_id");
        String transcript = request.getParameter("transcript");

        if (patientId == null || patientId.trim().isEmpty()) {
            message = "환자 ID가 없습니다.";
        } else if (transcript == null || transcript.trim().isEmpty()) {
            message = "저장할 음성 텍스트가 없습니다.";
        } else {
            Path savedPath = EmrRecordStorage.saveVoiceDraft(patientId, transcript);
            path = "patients/" + patientId.replaceAll("[^A-Za-z0-9_-]", "_") + "/" + savedPath.getFileName().toString();
            success = true;
            message = "음성 EMR 파일이 저장되었습니다.";
        }
    } catch (Exception e) {
        message = "서버 에러: " + e.getMessage();
        e.printStackTrace();
    }

    out.print("{");
    out.print("\"success\": " + success + ",");
    out.print("\"message\": \"" + message.replace("\"", "\\\"") + "\",");
    out.print("\"path\": \"" + path.replace("\"", "\\\"") + "\"");
    out.print("}");
%>
