<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>비트CARE+</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
  <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
  <link rel="stylesheet" href="CSS/style.css">
  <link rel="stylesheet" href="CSS/WaitingList.css">
</head>
<body>
  <%
    HttpSession usersession = request.getSession();
    String userName = (String) usersession.getAttribute("userName");
    Boolean isLoggedIn = (Boolean) usersession.getAttribute("isLoggedIn");
  %>

  <nav class="navbar navbar-expand-lg navbar-dark px-3">
    <div class="container-fluid">
      <a class="navbar-brand d-flex align-items-center" href="main.jsp">
        <img src="images/로고.png" alt="로고">
        <span class="fw-bold">비트CARE+</span>
      </a>
      <div class="collapse navbar-collapse">
        <ul class="navbar-nav me-auto mb-2">
          <li class="nav-item"><a class="nav-link" href="smallMenu.jsp">Home</a></li>
          <li class="nav-item"><a class="nav-link" href="Map.jsp">Nurse</a></li>
          <li class="nav-item"><a class="nav-link" href="Doctor.jsp">Doctor</a></li>
          <li class="nav-item"><a class="nav-link" href="notice.jsp">공지사항</a></li>
        </ul>

        <!-- 검색창 -->
        <form class="d-flex me-3" action="search.jsp" method="get">
          <input class="form-control" type="text" placeholder="검색...">
        </form>

        <!-- 로그인 상태 표시 -->
        <div class="d-flex align-items-center">
          <% if (isLoggedIn != null && isLoggedIn) { %>
              <span class="navbar-text me-3">환영합니다, <%= userName %>님!</span>
              <a href="logout.jsp" class="btn btn-sm btn-outline-light">LogOut</a>
          <% } else { %>
              <a href="Login_Doctor.jsp" class="btn btn-sm btn-outline-light me-2">로그인</a>
              <a href="join.jsp" class="btn btn-sm btn-outline-warning">회원가입</a>
          <% } %>
        </div>
      </div>
    </div>
  </nav>
</body>
</html>
