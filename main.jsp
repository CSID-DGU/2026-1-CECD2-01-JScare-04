<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="com.emrDAO.WaitingDAO, com.emrBean.WaitingBean" %>
<%@ page import="com.emrDAO.HistoryDAO, com.emrBean.HistoryBean" %>
<%@ page import="com.emrDAO.PatientDAO, com.emrBean.PatientBean" %>

<%@ include file="header.jsp" %>

<%
    // --- [서버 로직] ---
    String selectedId = request.getParameter("selectId");

    WaitingBean currentPatient = null;

    WaitingDAO waitDao = WaitingDAO.getInstance();
    List<WaitingBean> waitingList = waitDao.getWaitingList();

    // 1. 대기 목록에서 선택된 환자 검색
    if (waitingList != null && selectedId != null) {
        for (WaitingBean w : waitingList) {
            if (w.getPatientId().equals(selectedId)) {
                currentPatient = w;
                break;
            }
        }
    }

    // 2. 대기 목록에 없으면 patient 테이블에서 조회
    if (currentPatient == null && selectedId != null) {
        PatientDAO pDao = PatientDAO.getInstance();
        PatientBean pBean = pDao.getPatientById(selectedId);
        if (pBean != null) {
            currentPatient = new WaitingBean();
            currentPatient.setPatientId(pBean.getId());
            currentPatient.setPatientName(pBean.getName());
            currentPatient.setGender(pBean.getGender());
            currentPatient.setBirth(pBean.getBirth());
            currentPatient.setPhone(pBean.getPhone());
            currentPatient.setState("비대기");
            currentPatient.setEntryDate(null);
        }
    }

    // 3. 아무도 선택 안 됐으면 대기 목록 첫 번째
    if (currentPatient == null && waitingList != null && !waitingList.isEmpty()) {
        currentPatient = waitingList.get(0);
        selectedId = currentPatient.getPatientId();
    }
%>

<style>
    body { background-color: #f5f6fa; }

    .content-area {
        flex: 1;
        padding: 20px;
        overflow-y: auto;
        height: calc(100vh - 56px);
    }

    .panel-box {
        background: #fff;
        border: 1px solid #eee;
        border-radius: 10px;
        padding: 20px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        height: 100%;
        display: flex;
        flex-direction: column;
    }

    .section-title {
        font-size: 1rem;
        font-weight: bold;
        color: #2c3e50;
        border-bottom: 2px solid #0d6efd;
        padding-bottom: 8px;
        margin-bottom: 15px;
        flex-shrink: 0;
    }

    .info-table th { width: 80px; color: #666; font-weight: normal; font-size: 0.85rem; vertical-align: middle; }
    .info-table td { font-weight: bold; color: #333; font-size: 0.85rem; }

    /* ===== 달력 ===== */
    .cal-nav {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 8px;
    }
    .cal-nav .cal-title { font-weight: bold; font-size: 0.9rem; color: #2c3e50; }
    .cal-nav button {
        background: none;
        border: 1px solid #dee2e6;
        border-radius: 4px;
        padding: 2px 10px;
        cursor: pointer;
        font-size: 0.9rem;
        color: #495057;
        line-height: 1.5;
    }
    .cal-nav button:hover { background: #f1f3f5; }

    .cal-grid {
        display: grid;
        grid-template-columns: repeat(7, 1fr);
        gap: 2px;
        margin-bottom: 14px;
    }
    .cal-dow {
        text-align: center;
        font-size: 0.72rem;
        color: #868e96;
        padding: 4px 0;
        font-weight: 600;
    }
    .cal-dow.sun { color: #e03131; }
    .cal-dow.sat { color: #1971c2; }

    .cal-day {
        text-align: center;
        padding: 5px 2px;
        border-radius: 6px;
        cursor: pointer;
        font-size: 0.78rem;
        line-height: 1.2;
        min-height: 28px;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        transition: background 0.1s;
    }
    .cal-day:hover  { background: #f1f3f5; }
    .cal-day.empty  { cursor: default; }
    .cal-day.sun    { color: #e03131; }
    .cal-day.sat    { color: #1971c2; }
    .cal-day.today  { font-weight: bold; color: #0d6efd; }
    .cal-day.selected {
        background: #0d6efd !important;
        color: #fff !important;
        border-radius: 6px;
    }
    /* 예약 있는 날짜 점 표시 */
    .cal-day.has-appt::after {
        content: '';
        display: block;
        width: 4px;
        height: 4px;
        border-radius: 50%;
        background: #0d6efd;
        margin-top: 2px;
    }
    .cal-day.selected.has-appt::after { background: #fff; }

    /* ===== 예약 목록 ===== */
    .appt-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 8px;
        flex-shrink: 0;
    }
    .appt-title {
        font-size: 0.85rem;
        font-weight: bold;
        color: #495057;
        border-left: 3px solid #0d6efd;
        padding-left: 8px;
    }
    .appt-scroll {
        flex: 1;
        overflow-y: auto;
        min-height: 0;
    }
    .appt-card {
        border: 1px solid #dee2e6;
        border-radius: 8px;
        padding: 9px 12px;
        margin-bottom: 7px;
        cursor: pointer;
        display: flex;
        justify-content: space-between;
        align-items: center;
        transition: border-color 0.15s, background 0.15s;
        background: #fff;
    }
    .appt-card:hover  { border-color: #0d6efd; background: #f0f6ff; }
    .appt-name  { font-weight: bold; font-size: 0.88rem; }
    .appt-meta  { font-size: 0.75rem; color: #868e96; margin-top: 3px; }
    .appt-time  { font-size: 0.88rem; color: #0d6efd; font-weight: bold; text-align: right; }
    .appt-dept  { font-size: 0.72rem; color: #868e96; text-align: right; margin-top: 2px; }
    .appt-empty {
        text-align: center;
        color: #adb5bd;
        font-size: 0.83rem;
        padding: 25px 0;
    }
    .tag-type {
        display: inline-block;
        font-size: 0.68rem;
        padding: 1px 5px;
        border-radius: 10px;
        margin-left: 4px;
        vertical-align: middle;
    }
    .tag-new    { background: #e7f5ff; color: #1864ab; }
    .tag-return { background: #ebfbee; color: #2b8a3e; }
</style>

<div class="d-flex">

    <jsp:include page="sidebar.jsp" />

    <div class="content-area">

        <%-- 상단 현황 바 --%>
        <div class="row mb-3">
            <div class="col-12">
                <div class="alert alert-light border d-flex justify-content-between align-items-center py-2 mb-0">
                    <span><strong>Today:</strong> <%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %></span>
                    <span>현재 조회 중: <strong><%= currentPatient != null ? currentPatient.getPatientName() : "없음" %></strong></span>
                </div>
            </div>
        </div>

        <div class="row" style="height: calc(100vh - 175px);">

            <%-- ===== 왼쪽: 환자 상세 정보 ===== --%>
            <div class="col-md-4 h-100">
                <div class="panel-box">
                    <h3 class="section-title">👤 환자 상세 정보</h3>

                    <% if (currentPatient != null) { %>
                        <div class="text-center mb-3">
                            <img src="images/profile_placeholder.png"
                                 onerror="this.src='https://via.placeholder.com/80?text=User'"
                                 class="rounded-circle mb-2" width="80" height="80">
                            <h5 class="mb-0"><%= currentPatient.getPatientName() %></h5>
                            <small class="text-muted"><%= currentPatient.getPatientId() %></small>
                        </div>

                        <table class="table table-borderless info-table mb-0">
                            <tr>
                                <th>생년월일</th>
                                <td><%= currentPatient.getBirth() != null ? currentPatient.getBirth() : "-" %></td>
                            </tr>
                            <tr>
                                <th>성별</th>
                                <td><%= currentPatient.getGender() != null ? currentPatient.getGender() : "-" %></td>
                            </tr>
                            <tr>
                                <th>연락처</th>
                                <td><%= currentPatient.getPhone() != null ? currentPatient.getPhone() : "-" %></td>
                            </tr>
                            <tr>
                                <th>현재 상태</th>
                                <td>
                                    <% String st = currentPatient.getState(); %>
                                    <span class="badge bg-<%= "진료중".equals(st) ? "success" : "비대기".equals(st) ? "secondary" : "primary" %>">
                                        <%= st %>
                                    </span>
                                </td>
                            </tr>
                            <tr>
                                <th>접수 시간</th>
                                <td><%= currentPatient.getEntryDate() != null ? currentPatient.getEntryDate() : "-" %></td>
                            </tr>
                        </table>

                        <div class="d-grid gap-2 mt-auto pt-3">
                            <button class="btn btn-outline-primary btn-sm" type="button"
                                    onclick="alert('기능 준비중입니다.')">상세 정보 수정</button>
                            <button class="btn btn-primary btn-sm" type="button"
                                    onclick="location.href='Doctor.jsp?selectId=<%= currentPatient.getPatientId() %>'">
                                진료실로 이동
                            </button>
                        </div>

                    <% } else { %>
                        <div class="d-flex align-items-center justify-content-center flex-grow-1 text-muted text-center small">
                            왼쪽 목록에서 환자를 선택하거나<br>상단 검색창을 이용하세요.
                        </div>
                    <% } %>
                </div>
            </div>

            <%-- ===== 오른쪽: 달력 + 예약 목록 ===== --%>
            <div class="col-md-8 h-100">
                <div class="panel-box">
                    <h3 class="section-title">📅 예약 달력</h3>

                    <%-- 달력 --%>
                    <div class="cal-nav">
                        <button id="calPrevBtn">&#8249;</button>
                        <span class="cal-title" id="calTitle"></span>
                        <button id="calNextBtn">&#8250;</button>
                    </div>
                    <div class="cal-grid" id="calGrid"></div>

                    <%-- 예약 목록 헤더 --%>
                    <div class="appt-header">
                        <div class="appt-title" id="apptTitle">날짜를 선택하세요</div>
                        <span class="badge bg-primary" id="apptBadge" style="display:none;"></span>
                    </div>

                    <%-- 예약 카드 목록 (스크롤 영역) --%>
                    <div class="appt-scroll" id="apptScroll">
                        <div class="appt-empty">달력에서 날짜를 선택하면<br>예약 목록이 표시됩니다.</div>
                    </div>

                </div>
            </div>

        </div><%-- /row --%>
    </div><%-- /content-area --%>
</div>

<script>
    /* =====================================================
     * 달력 + 예약 조회
     *  - ajax/getAppointmentDates.jsp : 월별 점 표시용
     *  - ajax/getAppointments.jsp     : 날짜별 예약 목록
     * ===================================================== */

    var today    = new Date();
    var calYear  = today.getFullYear();
    var calMonth = today.getMonth();   // 0-based
    var selDay   = today.getDate();

    // 월별 예약 날짜 캐시  { "2026-04": ["2026-04-11", ...] }
    var dateCache = {};

    /* ── 달력 렌더링 ── */
    function renderCalendar() {
        var months = ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'];
        document.getElementById('calTitle').textContent = calYear + '년 ' + months[calMonth];

        var grid = document.getElementById('calGrid');
        grid.innerHTML = '';

        // 요일 헤더
        ['일','월','화','수','목','금','토'].forEach(function(d, i) {
            var el = document.createElement('div');
            el.className = 'cal-dow' + (i === 0 ? ' sun' : i === 6 ? ' sat' : '');
            el.textContent = d;
            grid.appendChild(el);
        });

        var firstDow = new Date(calYear, calMonth, 1).getDay();
        var lastDate = new Date(calYear, calMonth + 1, 0).getDate();

        // 빈 셀
        for (var i = 0; i < firstDow; i++) {
            var el = document.createElement('div');
            el.className = 'cal-day empty';
            grid.appendChild(el);
        }

        var cacheKey    = calYear + '-' + String(calMonth + 1).padStart(2, '0');
        var apptDates   = dateCache[cacheKey] || [];

        for (var d = 1; d <= lastDate; d++) {
            var el      = document.createElement('div');
            var dow     = new Date(calYear, calMonth, d).getDay();
            var dateStr = calYear + '-'
                        + String(calMonth + 1).padStart(2, '0') + '-'
                        + String(d).padStart(2, '0');

            el.className = 'cal-day';
            if (dow === 0) el.classList.add('sun');
            if (dow === 6) el.classList.add('sat');
            if (calYear  === today.getFullYear()
             && calMonth  === today.getMonth()
             && d         === today.getDate()) {
                el.classList.add('today');
            }
            if (calYear  === today.getFullYear()
             && calMonth  === today.getMonth()
             && d         === selDay) {
                el.classList.add('selected');
            }
            if (apptDates.indexOf(dateStr) >= 0) {
                el.classList.add('has-appt');
            }

            el.textContent   = d;
            el.dataset.date  = dateStr;
            el.addEventListener('click', function() {
                selDay = parseInt(this.textContent);
                renderCalendar();
                loadAppointments(this.dataset.date);
            });
            grid.appendChild(el);
        }
    }

    /* ── 월별 예약 날짜 조회 (점 표시) ── */
    function loadMonthDates(year, month) {
        var cacheKey = year + '-' + String(month + 1).padStart(2, '0');
        if (dateCache[cacheKey] !== undefined) {
            renderCalendar();
            return;
        }
        dateCache[cacheKey] = []; // 빈 배열로 초기화 (재요청 방지)

        $.ajax({
            type: 'GET',
            url:  'ajax/getAppointmentDates.jsp',
            data: { year: year, month: month + 1 },
            dataType: 'json',
            success: function(res) {
                if (res.dates) {
                    dateCache[cacheKey] = res.dates;
                }
                renderCalendar();
            },
            error: function() {
                renderCalendar(); // 실패해도 달력 표시
            }
        });
    }

    /* ── 날짜별 예약 목록 조회 ── */
    function loadAppointments(dateStr) {
        var scroll = document.getElementById('apptScroll');
        var title  = document.getElementById('apptTitle');
        var badge  = document.getElementById('apptBadge');

        var p = dateStr.split('-');
        title.textContent  = p[0] + '년 ' + parseInt(p[1]) + '월 ' + parseInt(p[2]) + '일 예약';
        badge.style.display = 'none';
        scroll.innerHTML   = '<div class="appt-empty">불러오는 중...</div>';

        $.ajax({
            type: 'GET',
            url:  'ajax/getAppointments.jsp',
            data: { date: dateStr },
            dataType: 'json',
            success: function(res) {
                if (res.error) {
                    scroll.innerHTML = '<div class="appt-empty text-danger">오류: ' + res.error + '</div>';
                    return;
                }

                var list = res.appointments || [];
                badge.textContent   = list.length + '건';
                badge.style.display = 'inline-block';

                if (!list.length) {
                    scroll.innerHTML = '<div class="appt-empty">이 날짜에 예약된 환자가 없습니다.</div>';
                    return;
                }

                var stColor = {
                    '예약'  : 'bg-primary',
                    '대기'  : 'bg-secondary',
                    '진료중': 'bg-success',
                    '완료'  : 'bg-secondary',
                    '취소'  : 'bg-danger'
                };

                var html = list.map(function(p) {
                    var sc  = stColor[p.state] || 'bg-secondary';
                    var tag = p.type === '초진'
                        ? '<span class="tag-type tag-new">초진</span>'
                        : '<span class="tag-type tag-return">재진</span>';
                    return '<div class="appt-card" onclick="location.href=\'main.jsp?selectId=' + p.patientId + '\'">'
                         +   '<div>'
                         +     '<div class="appt-name">' + p.name + tag + '</div>'
                         +     '<div class="appt-meta">'
                         +       p.birth + ' &nbsp;·&nbsp; ' + p.gender
                         +       ' &nbsp;<span class="badge ' + sc + '">' + p.state + '</span>'
                         +       (p.doctor ? ' &nbsp;<span class="text-muted">Dr. ' + p.doctor + '</span>' : '')
                         +     '</div>'
                         +   '</div>'
                         +   '<div>'
                         +     '<div class="appt-time">' + p.time + '</div>'
                         +     '<div class="appt-dept">' + p.dept + '</div>'
                         +   '</div>'
                         + '</div>';
                }).join('');

                scroll.innerHTML = html;

                // 예약 있는 날짜를 캐시에 추가해 점 표시 업데이트
                var ck = p[0] + '-' + p[1];
                if (dateCache[ck] && dateCache[ck].indexOf(dateStr) < 0 && list.length > 0) {
                    dateCache[ck].push(dateStr);
                    renderCalendar();
                }
            },
            error: function() {
                scroll.innerHTML = '<div class="appt-empty text-danger">서버 통신 오류가 발생했습니다.</div>';
            }
        });
    }

    /* ── 이전 / 다음 달 버튼 ── */
    document.getElementById('calPrevBtn').addEventListener('click', function() {
        calMonth--;
        if (calMonth < 0) { calMonth = 11; calYear--; }
        selDay = -1; // 날짜 선택 해제
        loadMonthDates(calYear, calMonth);
    });

    document.getElementById('calNextBtn').addEventListener('click', function() {
        calMonth++;
        if (calMonth > 11) { calMonth = 0; calYear++; }
        selDay = -1;
        loadMonthDates(calYear, calMonth);
    });

    /* ── 초기화: 오늘 날짜 자동 로드 ── */
    $(document).ready(function() {
        var todayStr = today.getFullYear() + '-'
                     + String(today.getMonth() + 1).padStart(2, '0') + '-'
                     + String(today.getDate()).padStart(2, '0');
        loadMonthDates(calYear, calMonth);
        loadAppointments(todayStr);
    });

    /* ── 사이드바 클릭 핸들러 ── */
    function onPatientClick(patientId) {
        location.href = 'main.jsp?selectId=' + patientId;
    }
</script>

</body>
</html>
