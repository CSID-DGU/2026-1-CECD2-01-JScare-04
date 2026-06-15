<%@ page import="java.util.*, com.emrDAO.HistoryDAO, com.emrBean.HistoryBean" %>
<%
  response.setContentType("application/json; charset=UTF-8");
  String patientId = request.getParameter("patientId");
  HistoryDAO dao = HistoryDAO.getInstance();
  List<HistoryBean> list = dao.getHistoryByPatient(patientId);
%>
[
<%
  for (int i = 0; i < list.size(); i++) {
    HistoryBean h = list.get(i);
    out.print("{");
    out.print("\"date\":\"" + h.getEntryDate() + "\",");
    out.print("\"dept\":\"" + h.getDeptId() + "\",");
    out.print("\"memo\":\"" + h.getMemo() + "\"");
    out.print("}");
    if (i < list.size() - 1) out.print(",");
  }
%>
]
