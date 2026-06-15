<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.emrDAO.HistoryDAO, com.emrDAO.PatientDAO, com.emrBean.HistoryBean, java.util.UUID" %>

<%
    request.setCharacterEncoding("UTF-8");
    
    boolean success = false;
    String message = "";

    try {
        // 파라미터 수신
        String historyId = request.getParameter("history_id");
        String patientId = request.getParameter("patient_id");
        String chiefComplaint = request.getParameter("chief_complaint");
        String presentIllness = request.getParameter("present_illness");
        String pastHistory = request.getParameter("past_history");
        String labResults = request.getParameter("lab_results");
        String imagingResults = request.getParameter("imaging_results");
        String diagnosis = request.getParameter("diagnosis");
        String plan = request.getParameter("plan");
        String freeText = request.getParameter("free_text");
        
        // 세션 처리
        String employeeId = (String) session.getAttribute("Id");
        if(employeeId == null) employeeId = "2018111650"; 

        // 숫자 변환
        String bpSysStr = request.getParameter("bp_systolic");
        String bpDiaStr = request.getParameter("bp_diastolic");
        String tempStr = request.getParameter("temp");
        String weightStr = request.getParameter("weight");
        String heightStr = request.getParameter("height"); 
        String hr = request.getParameter("hr");
        String rr = request.getParameter("rr");
        String spo2 = request.getParameter("spo2");

        int bpSystolic = (bpSysStr == null || bpSysStr.trim().isEmpty()) ? 0 : Integer.parseInt(bpSysStr);
        int bpDiastolic = (bpDiaStr == null || bpDiaStr.trim().isEmpty()) ? 0 : Integer.parseInt(bpDiaStr);
        float temp = (tempStr == null || tempStr.trim().isEmpty()) ? 0.0f : Float.parseFloat(tempStr);
        float weight = (weightStr == null || weightStr.trim().isEmpty()) ? 0.0f : Float.parseFloat(weightStr);
        float height = (heightStr == null || heightStr.trim().isEmpty()) ? 0.0f : Float.parseFloat(heightStr);

        if (patientId != null && !patientId.trim().isEmpty()) {
            HistoryDAO dao = HistoryDAO.getInstance();
            HistoryBean bean = new HistoryBean();
            
            // 공통 데이터 세팅
            bean.setPatientId(patientId);
            bean.setEmployeeId(employeeId);
            bean.setDeptId("01"); 
            bean.setMemo(plan);
            bean.setSymptomDetail(chiefComplaint);
            bean.setBpSystolic(bpSystolic);
            bean.setBpDiastolic(bpDiastolic);
            bean.setTemp(temp);
            bean.setWeight(weight);
            bean.setHeight(height); 
            bean.setChiefComplaint(chiefComplaint);
            bean.setPresentIllness(presentIllness);
            bean.setPastHistory(pastHistory);
            bean.setHr(hr);
            bean.setRr(rr);
            bean.setSpo2(spo2);
            bean.setLabResults(labResults);
            bean.setImagingResults(imagingResults);
            bean.setDiagnosis(diagnosis);
            bean.setPlan(plan);
            bean.setFreeText(freeText);

            // [분기 처리]
            if (historyId != null && !historyId.trim().isEmpty()) {
                bean.setId(historyId);
                success = dao.updateHistory(bean);
                message = success ? "진료 기록이 수정되었습니다." : "수정 실패";
            } else {
                bean.setId(UUID.randomUUID().toString().substring(0, 8));
                success = dao.insertHistory(bean);
                message = success ? "진료 기록이 저장되었습니다." : "저장 실패";
            }

            if (success) {
                PatientDAO.getInstance().updateVitals(patientId, height, weight, bpSystolic, bpDiastolic, temp, hr, rr, spo2);
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
