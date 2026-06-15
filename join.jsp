<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.emrDAO.DbConfig" %>
<%@ include file="header.jsp" %>
<%
    java.util.List<String[]> deptList = new java.util.ArrayList<String[]>();
    try (Connection conn = DbConfig.getConnection();
         PreparedStatement pstmt = conn.prepareStatement("SELECT id, name FROM dept ORDER BY name");
         ResultSet rs = pstmt.executeQuery()) {
        while (rs.next()) {
            deptList.add(new String[] { rs.getString("id"), rs.getString("name") });
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>회원가입</title>
<link rel="stylesheet" href="style.css">
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

<script>
$(document).ready(function(){
    $("form").submit(function(event){
        var password = $("#password").val();
        var confirmPassword = $("#confirmPassword").val();

        if (password !== confirmPassword) {
            alert("비밀번호가 일치하지 않습니다.");
            event.preventDefault();
        }
    });
});
</script>

<style>
/* 디자인 유지 */
* { margin: 0; padding: 0; box-sizing: border-box; }
.content { display: flex; justify-content: center; align-items: center; height: 80vh; }
.signup-container {
    width: 400px; padding: 20px; background-color: white;
    border: 1px solid #ccc; border-radius: 10px;
    box-shadow: 0 0 10px rgba(0,0,0,0.1);
}
h2 { text-align: center; margin-bottom: 20px; }
label { display: block; margin-top: 10px; font-weight: bold; }
input, select {
    width: 100%; padding: 10px; margin-top: 5px; margin-bottom: 15px;
    border: 1px solid #ccc; border-radius: 5px;
}
button {
    width: 100%; padding: 10px;
    background-color: #9abf7f; color: white; border: none;
    border-radius: 5px; cursor: pointer;
}
button:hover {
    background: linear-gradient(to top, #fbbd62, #9abf7f);
}
</style>
</head>

<body>
<div class="content">
  <div class="signup-container">
    <h2>회원가입</h2>
    <form action="joinProcess.jsp" method="post">
    
      <label for="name">이름</label>
      <input type="text" id="name" name="name" required>

      <label for="userId">아이디</label>
      <input type="text" id="Id" name="id" maxlength="50" required>

      <label for="password">비밀번호</label>
      <input type="password" id="password" name="pw" required>

      <label for="confirmPassword">비밀번호 확인</label>
      <input type="password" id="confirmPassword" name="confirmPassword" required>

      <label for="email">이메일</label>
      <input type="email" id="email" name="email" placeholder="example@dgu.ac.kr" required>

      <label for="phone">전화번호</label>
      <input type="text" id="phone" name="phone" placeholder="010-1234-5678" required>

      <label for="deptId">의료과</label>
      <select id="deptId" name="deptId" required>
        <option value="">의료과를 선택하세요</option>
        <% for (String[] dept : deptList) { %>
          <option value="<%= dept[0] %>"><%= dept[1] %></option>
        <% } %>
      </select>

      <button type="submit">가입하기</button>
    </form>
  </div>
</div>
</body>
</html>
