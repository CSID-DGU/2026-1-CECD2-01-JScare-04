<%@ page import="java.util.*, com.emrDAO.WaitingDAO, com.emrBean.WaitingBean" %>
<%
  response.setContentType("application/json; charset=UTF-8");
  WaitingDAO dao = WaitingDAO.getInstance();
  List<WaitingBean> list = dao.getWaitingList();
%>
[
<%
  for (int i = 0; i < list.size(); i++) {
    WaitingBean w = list.get(i);
    out.print("{");
    out.print("\"id\":\"" + w.getId() + "\",");
    out.print("\"name\":\"" + w.getPatientName() + "\",");
    out.print("\"gender\":\"" + w.getGender() + "\",");
    out.print("\"birth\":\"" + w.getBirth() + "\"");
    out.print("}");
    if (i < list.size() - 1) out.print(",");
  }
%>
]
