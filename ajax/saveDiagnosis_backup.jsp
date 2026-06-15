<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.emrDAO.HistoryDAO, com.emrBean.HistoryBean, java.util.UUID" %>

<%
    request.setCharacterEncoding("UTF-8");
    
    boolean success = false;
    String message = "";

    try {
        // 파라미터 수신
        String historyId = request.getParameter("history_id"); // [중요] 수정 시 이 값이 넘어옴
        String patientId = request.getParameter("patient_id");
        String symptomDetail = request.getParameter("symptom_detail");
        String memo = request.getParameter("memo");
        
        // 세션 처리 (없으면 임시 ID)
        String employeeId = (String) session.getAttribute("Id");
        if(employeeId == null) employeeId = "2018111650"; 

        // 숫자 변환
        String bpSysStr = request.getParameter("bp_systolic");
        String bpDiaStr = request.getParameter("bp_diastolic");
        String tempStr = request.getParameter("temp");
        String weightStr = request.getParameter("weight");

        int bpSystolic = (bpSysStr == null || bpSysStr.trim().isEmpty()) ? 0 : Integer.parseInt(bpSysStr);
        int bpDiastolic = (bpDiaStr == null || bpDiaStr.trim().isEmpty()) ? 0 : Integer.parseInt(bpDiaStr);
        float temp = (tempStr == null || tempStr.trim().isEmpty()) ? 0.0f : Float.parseFloat(tempStr);
        float weight = (weightStr == null || weightStr.trim().isEmpty()) ? 0.0f : Float.parseFloat(weightStr);

        if (patientId != null && !patientId.trim().isEmpty()) {
            HistoryDAO dao = HistoryDAO.getInstance();
            HistoryBean bean = new HistoryBean();
            
            // 공통 데이터 세팅
            bean.setPatientId(patientId);
            bean.setEmployeeId(employeeId);
            bean.setDeptId("01"); 
            bean.setMemo(memo);
            bean.setSymptomDetail(symptomDetail);
            bean.setBpSystolic(bpSystolic);
            bean.setBpDiastolic(bpDiastolic);
            bean.setTemp(temp);
            bean.setWeight(weight);
            bean.setHeight(0.0f);

            // [분기 처리] ID가 있으면 수정(UPDATE), 없으면 신규(INSERT)
            if (historyId != null && !historyId.trim().isEmpty()) {
                bean.setId(historyId); // 기존 ID 세팅
                success = dao.updateHistory(bean);
                message = success ? "진료 기록이 수정되었습니다." : "수정 실패";
            } else {
                bean.setId(UUID.randomUUID().toString().substring(0, 8)); // 새 ID 생성
                success = dao.insertHistory(bean);
                message = success ? "진료 기록이 저장되었습니다." : "저장 실패";
            }
        } else {
            message = "환자 ID가 없습니다.";
        }

    } catch (Exception e) {
        message = "서버 에러: " + e.getMessage();
        e.printStackTrace();
    }

    out.print("{\"success\": " + success + ", \"message\": \"" + message + "\"}");
%>