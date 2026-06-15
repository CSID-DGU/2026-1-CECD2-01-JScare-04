<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.emrDAO.LoginDAO" %>  

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<% request.setCharacterEncoding("UTF-8"); %>
	<!-- jsp 빈 사용 -->
	<jsp:useBean id="loginBean" class="com.emrBean.LoginBean"/>
	<jsp:setProperty name="loginBean" property="*"/>


	
	<%
	LoginDAO dao=LoginDAO.getInstance();  
	
	String ismember=dao.isMember(loginBean);	
	
	if(ismember.equals("null")){
	%>
	
	    <script type="text/javascript">
	    	alert("회원정보를 찾을 수 없습니다. 다시 입력해주세요.");
	        //자동으로 로그인 페이지로 리다이렉트
	        window.location.href = "Login_Doctor.jsp";
   		</script>
   		
	<%
	}
	else{
		
		HttpSession usersession = request.getSession();  // 세션 객체 가져오기
		    
	    // 로그인 정보 확인 후 로그인 성공 시
	    usersession.setAttribute("Id", loginBean.getId());
	    usersession.setAttribute("userName", ismember);
	    usersession.setAttribute("isLoggedIn", true);  // 로그인 상태 플래그
		//세션 객체 유효시간 설정
		usersession.setMaxInactiveInterval(20*60);
	    // 로그인 후 메인 페이지로 리다이렉트
	    response.sendRedirect("main.jsp");
		
	%>
	
		<script type="text/javascript">
	        window.location.href = "main.jsp"; // 메인화면으로 돌아가도록 리다이렉트
	    </script>
	    
	<%
	}
		
	 %>
	         
	 
</body>
</html>