<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<% 
    HttpSession usersession = request.getSession();  // 세션 객체 가져오기
    usersession.invalidate();  // 세션을 무효화하여 모든 세션 속성 삭제
    
    // 로그아웃 후 로그인 페이지로 리다이렉트
    response.sendRedirect("main.jsp");
%>

</body>
</html>