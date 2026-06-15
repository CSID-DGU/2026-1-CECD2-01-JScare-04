<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, com.emrDAO.PatientDAO, com.emrBean.PatientBean" %>
<%
    String keyword = request.getParameter("keyword");
    PatientDAO dao = PatientDAO.getInstance();
    
    // PatientBean이 없다면 WaitingBean 등을 사용해도 됩니다.
    // 여기서는 로직 설명을 위해 PatientBean을 사용한다고 가정합니다.
    List<PatientBean> list = dao.searchPatients(keyword);
%>
[
<%
    for (int i = 0; i < list.size(); i++) {
        PatientBean p = list.get(i);
        out.print("{");
        out.print("\"id\":\"" + p.getId() + "\",");
        out.print("\"name\":\"" + p.getName() + "\",");
        out.print("\"birth\":\"" + p.getBirth() + "\",");
        out.print("\"gender\":\"" + p.getGender() + "\"");
        out.print("}");
        if (i < list.size() - 1) out.print(",");
    }
%>
]