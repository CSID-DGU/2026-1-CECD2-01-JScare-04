<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.emrDAO.AppointmentDAO" %>
<%
    request.setCharacterEncoding("UTF-8");
    response.setContentType("application/json; charset=UTF-8");

    String yearStr  = request.getParameter("year");
    String monthStr = request.getParameter("month");

    // 1. DAO를 통해 예약 날짜 목록 가져오기
    AppointmentDAO dao = AppointmentDAO.getInstance();
    List<String> dates = dao.getAppointmentDates(yearStr, monthStr);

    // 2. JSON 문자열 조립
    StringBuilder sb = new StringBuilder();
    sb.append("{\"dates\":[");

    for (int i = 0; i < dates.size(); i++) {
        if (i > 0) sb.append(",");
        sb.append("\"").append(dates.get(i)).append("\"");
    }
    sb.append("]}");

    // 3. 결과 출력
    out.print(sb.toString());
%>