<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>로그인</title>
    <script src="https://code.jquery.com/jQuery-3.7.1.js"></script>
    <link rel="stylesheet" href="CSS/Login_Doctor.css">
     
    <style>

    </style>
</head>


<body>
<div class="login-box">
    <h2>SENSORCUBE<br>TEMP MONITORING SYSTEM</h2>

    <form action="loginprocess.jsp" method="post">
        <div class="row">
            <label for="userId">ID</label>
            <input type="text" id="userId" name="id" required>
        </div>

        <div class="row">
            <label for="password">PW</label>
            <input type="password" id="password" name="pw" required>
        </div>

        <div class="row">
            <button type="submit" class="login-btn">LOGIN</button>
            <button type="button" class="join-btn" onclick="location.href='join.jsp'">JOIN</button>
        </div>

    </form>
</div>
</body>
</html>
