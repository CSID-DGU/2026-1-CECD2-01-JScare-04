<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="com.emrDAO.WaitingDAO, com.emrBean.WaitingBean" %>
<%@ page import="com.emrDAO.HistoryDAO, com.emrBean.HistoryBean" %>
<%@ page import="com.emrDAO.PatientDAO, com.emrBean.PatientBean" %>

<%@ include file="header.jsp" %>

<%
    // --- [임시 데이터 생성] DB 연동 전 화면 확인용 ---
    // 추후 DB연동할 예정.
    List<Map<String, String>> noticeList = new ArrayList<>();
    
    // 임시 데이터
    Map<String, String> n1 = new HashMap<>();
    n1.put("no", "공지"); n1.put("title", "[긴급] 서버 시스템 점검 예정"); n1.put("views", "253"); n1.put("date", "2025-12-10"); n1.put("type", "star");
    noticeList.add(n1);

    Map<String, String> n2 = new HashMap<>();
    n2.put("no", "10"); n2.put("title", "[공지] 12월 근무 로테이션 안내"); n2.put("views", "220"); n2.put("date", "2025-11-20"); n2.put("type", "normal");
    noticeList.add(n2);

    Map<String, String> n3 = new HashMap<>();
    n3.put("no", "9"); n3.put("title", "[공지] 겨울철 방한 대비 안전 수칙"); n3.put("views", "159"); n3.put("date", "2024-12-09"); n3.put("type", "normal");
    noticeList.add(n3);

    Map<String, String> n4 = new HashMap<>();
    n4.put("no", "8"); n4.put("title", "[긴급] 시스템 점검 및 업그레이드 안내"); n4.put("views", "561"); n4.put("date", "2024-12-08"); n4.put("type", "important");
    noticeList.add(n4);
    
%>

<style>
    body { 
        background-color: #f5f6fa; 
        overflow: hidden;
    }

    .content-area {
        flex: 1;
        padding: 30px;
        height: calc(100vh - 56px);
        overflow-y: auto;
    }

    .notice-panel {
        background: #fff;
        border: 1px solid #ddd;
        border-radius: 8px; /* 둥근 모서리 */
        padding: 30px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.05);
        min-height: 100%; 
    }

    /* 공지사항 제목 */
    .page-title {
        font-size: 1.8rem;
        font-weight: 800;
        color: #212529;
        margin-bottom: 20px;
    }

    /* 검색창 */
    .search-bar-wrapper {
        display: flex;
        justify-content: flex-end;
        margin-bottom: 15px;
    }

    .notice-table {
        width: 100%;
        border-top: 2px solid #333;
    }
    .notice-table th {
        background-color: #f8f9fa;
        text-align: center;
        padding: 15px 0;
        border-bottom: 1px solid #ddd;
        font-weight: 600;
        color: #555;
    }
    .notice-table td {
        padding: 15px 10px;
        border-bottom: 1px solid #eee;
        vertical-align: middle;
        color: #333;
    }
    .notice-table tr:hover {
        background-color: #f8f9fa;
    }
    
    .notice-link {
        text-decoration: none;
        color: #333;
        display: block;
    }
    .notice-link:hover {
        color: #0d6efd;
        font-weight: 500;
    }

    /* 아이콘 등 유틸리티 */
    .icon-star { color: #0d6efd; margin-right: 5px; }
    .icon-notice { color: #6c757d; margin-right: 5px; }
</style>

<div class="d-flex">
    
    <jsp:include page="sidebar.jsp" />

    <div class="content-area">
        
        <div class="notice-panel">
            <div class="page-title">공지사항</div>

            <div class="search-bar-wrapper">
                <div class="input-group" style="width: 300px;">
                    <select class="form-select form-select-sm" style="max-width: 80px;">
                        <option>전체</option>
                        <option>제목</option>
                        <option>내용</option>
                    </select>
                    <input type="text" class="form-control form-control-sm" placeholder="검색어 입력">
                    <button class="btn btn-outline-secondary btn-sm" type="button">🔍</button>
                </div>
            </div>

            <table class="notice-table">
                <colgroup>
                    <col width="10%"> <col width="*">   <col width="10%"> <col width="15%"> </colgroup>
                <thead>
                    <tr>
                        <th>No.</th>
                        <th>제목</th>
                        <th>조회수</th>
                        <th>날짜</th>
                    </tr>
                </thead>
                <tbody>
                    <%-- 데이터 반복 출력 --%>
                    <% if (noticeList != null && !noticeList.isEmpty()) { %>
                        <% for (Map<String, String> notice : noticeList) { %>
                        <tr>
                            <td class="text-center">
                                <% if ("star".equals(notice.get("type"))) { %>
                                    <span class="icon-star">★</span>
                                <% } else if ("공지".equals(notice.get("no"))) { %>
                                    <span class="badge bg-light text-dark border">공지</span>
                                <% } else { %>
                                    <%= notice.get("no") %>
                                <% } %>
                            </td>

                            <td>
                                <a href="#" class="notice-link" onclick="alert('게시글 상세보기는 아직 구현되지 않았습니다.')">
                                    <%= notice.get("title") %>
                                </a>
                            </td>

                            <td class="text-center text-muted"><%= notice.get("views") %></td>

                            <td class="text-center text-muted"><%= notice.get("date") %></td>
                        </tr>
                        <% } %>
                    <% } else { %>
                        <tr>
                            <td colspan="4" class="text-center py-5 text-muted">등록된 공지사항이 없습니다.</td>
                        </tr>
                    <% } %>
                </tbody>
            </table>

            <div class="d-flex justify-content-center mt-4">
                <nav>
                    <ul class="pagination pagination-sm">
                        <li class="page-item disabled"><a class="page-link" href="#">&lt;</a></li>
                        <li class="page-item active"><a class="page-link" href="#">1</a></li>
                        <li class="page-item"><a class="page-link" href="#">2</a></li>
                        <li class="page-item"><a class="page-link" href="#">3</a></li>
                        <li class="page-item"><a class="page-link" href="#">&gt;</a></li>
                    </ul>
                </nav>
            </div>

        </div> </div> </div> </body>
</html>