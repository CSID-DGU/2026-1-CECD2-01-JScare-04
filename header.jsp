<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    HttpSession usersession = request.getSession();
    String userName = (String) usersession.getAttribute("userName");
    Boolean isLoggedIn = (Boolean) usersession.getAttribute("isLoggedIn");
%>
<!DOCTYPE html>
<html lang="ko">

<style>
/* 챗봇 윈도우 전체 틀 (기본 크기) */
#chatbot-window {
    position: fixed;
    bottom: 90px;
    right: 30px;
    width: 350px;
    height: 500px;
    z-index: 9999;
    display: none;
    flex-direction: column;
    background-color: #fff;
    border-radius: 15px;
    border: 1px solid #ddd;
    overflow: hidden; 
    transition: all 0.3s ease; /* 부드러운 크기 변경 애니메이션 */
}

/* [추가] 챗봇 확대 모드 (클래스 토글용) */
.chat-maximized {
    width: 500px !important;  /* 너비 확대 */
    height: 80vh !important;  /* 높이를 화면의 80%로 확대 */
}

/* 챗봇 헤더 */
#chat-header {
    background-color: #333; 
    color: white;           
    padding: 15px;
    display: flex;          
    justify-content: space-between; 
    align-items: center;    
}

/* 닫기 및 확대 버튼 스타일 */
.chat-header-btn {
    color: white;
    background: transparent;
    border: none;
    font-size: 1.2rem;
    line-height: 1;
    margin-left: 10px;
    cursor: pointer;
}
.chat-header-btn:hover { color: #ddd; }

/* 닫기 버튼 (흰색 필터) */
.btn-close-white-custom {
    filter: invert(1) grayscale(100%) brightness(200%); 
}

/* 채팅 내용 영역 */
#chat-body {
    flex: 1;
    padding: 15px;
    overflow-y: auto;
    background-color: #f8f9fa;
    display: flex;
    flex-direction: column;
    gap: 10px;
}

/* 말풍선 스타일 */
.chat-message {
    padding: 10px 14px;
    border-radius: 15px;
    max-width: 80%;
    word-wrap: break-word;
    font-size: 0.9rem;
    line-height: 1.4;
}
.bot-message {
    background-color: #e9ecef;
    color: #333;
    align-self: flex-start;
    border-bottom-left-radius: 2px;
}
.user-message {
    background-color: #0d6efd;
    color: white;
    align-self: flex-end;
    border-bottom-right-radius: 2px;
}

/* 작성 중(...) 애니메이션 */
.typing-indicator span {
    display: inline-block;
    width: 6px;
    height: 6px;
    background-color: #555;
    border-radius: 50%;
    animation: typing 1.4s infinite ease-in-out both;
    margin: 0 2px;
}
.typing-indicator span:nth-child(1) { animation-delay: -0.32s; }
.typing-indicator span:nth-child(2) { animation-delay: -0.16s; }
@keyframes typing {
    0%, 80%, 100% { transform: scale(0); }
    40% { transform: scale(1); }
}
</style>

<head>
  <meta charset="UTF-8">
  <title>비트CARE+</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
  <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
  
  <link rel="stylesheet" href="CSS/style.css">
  <link rel="stylesheet" href="CSS/header.css">
  
  <script>
      const contextPath = "${pageContext.request.contextPath}";
  </script>
  <script src="js/headerSearch.js"></script>
</head>
<body>

  <nav class="navbar navbar-expand-lg navbar-dark px-3 navbar-custom">
    <div class="container-fluid">
      <a class="navbar-brand d-flex align-items-center" href="main.jsp">
        <img src="CSS/images/logo.png" alt="로고" style="height: 40px; margin-right: 5px;">
        <span class="fw-bold">비트CARE+</span>
      </a>
      <div class="collapse navbar-collapse">
        <ul class="navbar-nav me-auto mb-2" style="margin-top: 3px">
          <li class="nav-item"><a class="nav-link" href="main.jsp">Home</a></li>
          <li class="nav-item"><a class="nav-link" href="Nurse.jsp">Nurse</a></li>
          <li class="nav-item"><a class="nav-link" href="Doctor.jsp">Doctor</a></li>
          <li class="nav-item"><a class="nav-link" href="notice.jsp">공지사항</a></li>
        </ul>

        <div class="search-container d-flex me-3 position-relative">
            <input id="headerSearchInput" class="form-control" type="text" placeholder="환자명 또는 ID 검색..." autocomplete="off">
            <div id="search-results"></div>
        </div>

        <div class="d-flex align-items-center">
          <% if (isLoggedIn != null && isLoggedIn) { %>
              <span class="navbar-text me-3 text-white">환영합니다, <%= userName %>님!</span>
              <a href="logout.jsp" class="btn btn-sm btn-outline-light">LogOut</a>
          <% } else { %>
              <a href="Login_Doctor.jsp" class="btn btn-sm btn-outline-light me-2">로그인</a>
              <a href="join.jsp" class="btn btn-sm btn-outline-warning">회원가입</a>
          <% } %>
        </div>
      </div>
    </div>
  </nav>

  <div id="chatbot-window" class="card shadow">
    <div id="chat-header">
        <span class="fw-bold">비트CARE+ 도우미</span>
        <div class="d-flex align-items-center">
            <button type="button" id="btn-maximize" class="chat-header-btn fw-bold" onclick="toggleMaximize()" title="확대/축소">+</button>
            <button type="button" class="btn-close btn-close-white-custom ms-2" aria-label="Close" onclick="toggleChat()"></button>
        </div>
    </div>
    
    <div class="card-body" id="chat-body">
        <div class="chat-message bot-message">
            안녕하세요! 궁금한 점을 물어보세요.<br>AI가 답변해 드립니다.
        </div>
    </div>
    
    <div class="card-footer" id="chat-footer">
        <div class="input-group">
            <input type="text" id="chatInput" class="form-control" placeholder="질문을 입력하세요..." onkeypress="checkEnter(event)">
            <button class="btn btn-primary" type="button" id="send-btn" onclick="sendMessage()">전송</button>
        </div>
    </div>
</div>

  <div id="btn-aitutor-open-aiTutor" onclick="toggleChat()">
      <svg stroke="currentColor" fill="none" stroke-width="2" viewBox="0 0 24 24" stroke-linecap="round" stroke-linejoin="round" height="1em" width="1em" xmlns="http://www.w3.org/2000/svg">
          <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
          <path d="M4 21v-13a3 3 0 0 1 3 -3h10a3 3 0 0 1 3 3v6a3 3 0 0 1 -3 3h-9l-4 4"></path>
          <path d="M9.5 9h.01"></path>
          <path d="M14.5 9h.01"></path>
          <path d="M9.5 13a3.5 3.5 0 0 0 5 0"></path>
      </svg>
  </div>

  <script>
      // 1. 챗봇 열기/닫기
      function toggleChat() {
          var chatWindow = document.getElementById("chatbot-window");
          if (chatWindow.style.display === "none" || chatWindow.style.display === "") {
              chatWindow.style.display = "flex";
              $("#chatInput").focus(); 
          } else {
              chatWindow.style.display = "none";
          }
      }

      // [추가] 2. 챗봇 확대/축소 토글
      function toggleMaximize() {
          var chatWindow = $("#chatbot-window");
          var btn = $("#btn-maximize");

          // 클래스 유무로 상태 확인
          if (chatWindow.hasClass("chat-maximized")) {
              // 축소 (원복)
              chatWindow.removeClass("chat-maximized");
              btn.text("+"); // 아이콘을 +로 변경
          } else {
              // 확대
              chatWindow.addClass("chat-maximized");
              btn.text("-"); // 아이콘을 -로 변경
          }
      }

      function checkEnter(e) {
          if(e.key === 'Enter') sendMessage();
      }

      function scrollToBottom() {
          var chatBody = document.getElementById("chat-body");
          chatBody.scrollTop = chatBody.scrollHeight;
      }

      function sendMessage() {
          var input = $("#chatInput");
          var btn = $("#send-btn");
          var message = input.val().trim();
          
          if(message === "") return;

          // 메시지 표시 및 스크롤
          $("#chat-body").append('<div class="chat-message user-message">' + message + '</div>');
          input.val(""); 
          scrollToBottom();

          // 입력 잠금 및 로딩 표시
          input.prop("disabled", true);
          btn.prop("disabled", true);

          var loadingBubble = `
              <div id="chat-loading" class="chat-message bot-message">
                  <div class="typing-indicator">
                      <span></span><span></span><span></span>
                  </div>
              </div>`;
          $("#chat-body").append(loadingBubble);
          scrollToBottom();

          // 서버 전송
          $.ajax({
              type: "POST",
              url: "ajax/chatBot.jsp",
              data: { "message": message },
              dataType: "json",
              success: function(res) {
                  $("#chat-loading").remove();
                  var botReply = res.response; 
                  if(!botReply) botReply = "응답을 불러올 수 없습니다.";
                  
                  botReply = botReply.replace(/\n/g, "<br>");
                  $("#chat-body").append('<div class="chat-message bot-message">' + botReply + '</div>');
                  scrollToBottom();
              },
              error: function(xhr, status, error) {
                  $("#chat-loading").remove();
                  console.error("통신 에러:", error);
                  $("#chat-body").append('<div class="chat-message bot-message text-danger">서버 연결 실패</div>');
                  scrollToBottom();
              },
              complete: function() {
                  input.prop("disabled", false);
                  btn.prop("disabled", false);
                  input.focus();
              }
          });
      }
  </script>

</body>
</html>