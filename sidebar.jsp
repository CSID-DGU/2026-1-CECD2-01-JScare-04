<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="com.emrDAO.WaitingDAO, com.emrBean.WaitingBean" %>

<%
    // 데이터 로딩 로직
    WaitingDAO sidebarDao = WaitingDAO.getInstance();
    List<WaitingBean> sidebarList = sidebarDao.getWaitingList();
    
    // 현재 선택된 환자 ID 확인
    String currentId = request.getParameter("selectId");
%>

<style>
    /* [핵심] 단독 실행 시 브라우저 기본 여백(Gap) 제거 */
    body {
        margin: 0 !important;
        padding: 0 !important;
    }

    /* 사이드바 전체 틀 */
    .sidebar {
        width: 280px;
        background: #fff;
        border-right: 1px solid #ddd;
        height: 100vh; /* 단독 실행 시 화면 꽉 채우기 위해 100vh로 설정 (포함될 땐 부모 높이 따름) */
        overflow-y: auto;
        padding: 0;
        box-sizing: border-box; /* 패딩 포함 너비 계산 */
    }

    .sidebar-header {
        padding: 15px;
        background-color: #343a40;
        color: white;
        font-weight: bold;
        text-align: center;
    }

    /* a 태그처럼 동작하도록 스타일링 */
    .waiting-item {
        display: block;
        padding: 15px;
        border-bottom: 1px solid #eee;
        color: #333;
        text-decoration: none;
        cursor: pointer;
        transition: 0.2s;
        background-color: #fff;
    }

    .waiting-item:hover { 
        background-color: #f1f3f5; 
        color: #000; 
    }

    .waiting-item.active { 
        background-color: #e7f5ff; 
        border-left: 5px solid #0d6efd; 
    }
    
    /* 내부 텍스트 정리 */
    .d-flex { display: flex; justify-content: space-between; align-items: center; }
    .badge { padding: 3px 8px; border-radius: 10px; font-size: 0.8rem; color: white; }
    .bg-success { background-color: #198754; }
    .bg-secondary { background-color: #6c757d; }
    .small { font-size: 0.85rem; color: #6c757d; margin-top: 4px; }
</style>

<div class="sidebar">
    <div class="sidebar-header">
         대기 환자 목록 (<%= sidebarList != null ? sidebarList.size() : 0 %>명)
    </div>
    
    <% if (sidebarList == null || sidebarList.isEmpty()) { %>
        <div style="padding: 20px; text-align: center; color: #888;">
            대기 환자가 없습니다.
        </div>
    <% } else { %>
        <% for (WaitingBean w : sidebarList) { 
            boolean isActive = (currentId != null && currentId.equals(w.getPatientId()));
        %>
        
        <div class="waiting-item <%= isActive ? "active" : "" %>" 
             onclick="onPatientClick('<%= w.getPatientId() %>', '<%= w.getId() %>')">
            
            <div class="d-flex">
                <strong><%= w.getPatientName() %></strong>
                <span class="badge <%= "진료중".equals(w.getState()) ? "bg-success" : "bg-secondary" %>">
                    <%= w.getState() %>
                </span>
            </div>
            
            <div class="small">
                <%= w.getBirth() %> | <%= w.getGender() %>
            </div>
        </div>
        <% } %>
    <% } %>
</div>