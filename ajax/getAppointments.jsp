<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.emrDAO.AppointmentDAO" %>
<%@ page import="com.emrBean.AppointmentBean" %>
<%
    // 1. 요청 및 응답 인코딩/타입 설정
    request.setCharacterEncoding("UTF-8");
    response.setContentType("application/json; charset=UTF-8");

    // 2. 파라미터 받기
    String date = request.getParameter("date");

    // 3. 싱글톤 DAO를 호출하여 데이터 가져오기 (DB 관련 복잡한 로직은 DAO 내부에서 처리됨!)
    AppointmentDAO dao = AppointmentDAO.getInstance();
    List<AppointmentBean> list = dao.getAppointmentsByDate(date);

    // 4. 가져온 List 데이터를 JSON 문자열로 조립 (기존의 방식 유지)
    StringBuilder sb = new StringBuilder();
    sb.append("{\"appointments\":[");

    for (int i = 0; i < list.size(); i++) {
        AppointmentBean bean = list.get(i);
        
        if (i > 0) sb.append(","); // 두 번째 객체부터 쉼표 추가
        
        sb.append("{")
          .append("\"apptId\":\"")    .append(bean.getApptId())   .append("\",")
          .append("\"patientId\":\"") .append(bean.getPatientId()).append("\",")
          .append("\"name\":\"")      .append(bean.getName())     .append("\",")
          .append("\"birth\":\"")     .append(bean.getBirth())    .append("\",")
          .append("\"gender\":\"")    .append(bean.getGender())   .append("\",")
          .append("\"time\":\"")      .append(bean.getTime())     .append("\",")
          .append("\"dept\":\"")      .append(bean.getDept())     .append("\",")
          .append("\"doctor\":\"")    .append(bean.getDoctor())   .append("\",")
          .append("\"type\":\"")      .append(bean.getType())     .append("\",")
          .append("\"state\":\"")     .append(bean.getState())    .append("\",")
          .append("\"memo\":\"")      .append(bean.getMemo())     .append("\"")
          .append("}");
    }
    sb.append("]}");

    // 5. 최종 결과물 출력
    out.print(sb.toString());
%>