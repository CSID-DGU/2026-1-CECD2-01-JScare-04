<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.emrDAO.MemberDAO" %>    

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입 처리</title>
</head>
<body>
<%
    request.setCharacterEncoding("UTF-8");
%>

<jsp:useBean id="memberBean" class="com.emrBean.MemberBean" scope="request"/>
<jsp:setProperty name="memberBean" property="name"/>
<jsp:setProperty name="memberBean" property="id"/>
<jsp:setProperty name="memberBean" property="pw"/>
<jsp:setProperty name="memberBean" property="email"/>
<jsp:setProperty name="memberBean" property="phone"/>
<jsp:setProperty name="memberBean" property="deptId"/>
	
	<%
	//MemberDAO dao=MemberDAO.getInstance();   
	//boolean IDexists=dao.isIDExists(memberBean);	
	MemberDAO dao=new MemberDAO();
	boolean IDexists=dao.isIDExists(memberBean);	
	
	if(!IDexists){
	dao.joinMember(memberBean);
	%>
	    <script type="text/javascript">
	   		alert("회원가입에 성공했습니다!! 로그인 해주세요:)");
	        // 회원가입 성공 후 자동으로 로그인 페이지로 리다이렉트
	        window.location.href = "Login_Doctor.jsp";
   		</script>
	<%
	}
	else{
	%>
		<script type="text/javascript">
	        // 아이디 중복 시 경고 메시지 표시하고, 회원가입 폼 페이지로 리다이렉트
	        alert("아이디가 중복됩니다. 다른 아이디를 선택해주세요.");
	        window.location.href = "join.jsp"; // 폼으로 돌아가도록 리다이렉트
	    </script>
	<%
	}
		
	 %>
	         
	 
	
	
</body>
</html>
