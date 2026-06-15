<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="com.emrDAO.WaitingDAO, com.emrBean.WaitingBean" %>
<%@ page import="com.emrDAO.HistoryDAO, com.emrBean.HistoryBean" %>
<%@ page import="com.emrDAO.PatientDAO, com.emrBean.PatientBean" %>
<%@ page import="com.emrDAO.AppointmentDAO, com.emrBean.AppointmentBean" %>

<%@ include file="header.jsp" %>

<%
    // --- [서버 로직] ---
    request.setCharacterEncoding("UTF-8");

    WaitingDAO waitDao = WaitingDAO.getInstance();
    List<WaitingBean> waitingList = waitDao.getWaitingList();
    
    String selectedId = request.getParameter("selectId");
    WaitingBean currentPatient = null;
    
    // 1. 환자 찾기
    if (waitingList != null && !waitingList.isEmpty()) {
        if (selectedId == null) {
            currentPatient = waitingList.get(0);
        } else {
            for (WaitingBean w : waitingList) {
                if (w.getPatientId().equals(selectedId)) {
                    currentPatient = w;
                    break;
                }
            }
            if (currentPatient == null) {
                PatientDAO pDao = PatientDAO.getInstance();
                PatientBean p = pDao.getPatientById(selectedId);
                if(p != null) {
                    currentPatient = new WaitingBean();
                    currentPatient.setPatientId(p.getId());
                    currentPatient.setPatientName(p.getName());
                    currentPatient.setGender(p.getGender());
                    currentPatient.setBirth(p.getBirth());
                    currentPatient.setState("조회중");
                }
            }
        }
    }
    
    // 2. 과거 진료 기록 및 예약 기록 조회
    List<HistoryBean> historyList = null;
    List<AppointmentBean> apptList = null;

    if (currentPatient != null) {
        HistoryDAO hDao = HistoryDAO.getInstance();
        historyList = hDao.getHistoryByPatient(currentPatient.getPatientId());
        
        AppointmentDAO aDao = AppointmentDAO.getInstance();
        apptList = aDao.getAppointmentsByPatient(currentPatient.getPatientId());
    }
%>

<style>
    /* [기본 레이아웃] */
    body { background-color: #f5f6fa; overflow: hidden; margin: 0 !important; padding: 0 !important; }
    
    /* 사이드바 스타일 */
    .sidebar {
        width: 280px;
        background: #fff;
        border-right: 1px solid #ddd;
        height: calc(100vh - 56px);
        overflow-y: auto;
        flex-shrink: 0;
    }
    .sidebar-header {
        padding: 15px;
        background-color: #343a40;
        color: white;
        font-weight: bold;
        text-align: center;
    }
    .waiting-item {
        display: block;
        padding: 15px;
        border-bottom: 1px solid #eee;
        color: #333;
        text-decoration: none;
        transition: 0.2s;
        cursor: pointer;
    }
    .waiting-item:hover { background-color: #f1f3f5; color: #000; }
    .waiting-item.active { background-color: #e7f5ff; border-left: 5px solid #0d6efd; }

    /* 콘텐츠 영역 */
    .content-area {
        flex: 1;
        padding: 15px;
        overflow-y: hidden;
        height: calc(100vh - 56px);
    }
    .panel-box {
        background: #fff;
        border: 1px solid #ccc;
        border-radius: 4px;
        padding: 0;
        overflow: hidden;
        display: flex;
        flex-direction: column;
    }

    /* [EMR 스타일 전용 CSS] */
    .emr-header {
        background-color: #e9ecef;
        border-bottom: 1px solid #ced4da;
        padding: 8px 15px;
        font-size: 0.9rem;
        font-weight: bold;
        color: #495057;
        display: flex;
        justify-content: space-between;
        align-items: center;
        flex-shrink: 0;
    }
    
    .emr-section-label {
        font-size: 0.85rem;
        font-weight: bold;
        color: #666;
        margin-top: 10px;
        margin-bottom: 5px;
        display: block;
        border-left: 3px solid #0d6efd;
        padding-left: 8px;
    }

    .emr-input { font-size: 0.9rem; border-radius: 2px; }
    .input-group-text { font-size: 0.8rem; background-color: #f8f9fa; }
    textarea { resize: none; }
    .emr-chart-body {
        flex: 1;
        display: grid;
        grid-template-rows: auto auto 1fr auto auto;
        gap: 12px;
        padding: 14px;
        overflow-y: auto;
        background: #f8f9fa;
    }
    .emr-block {
        background: #fff;
        border: 1px solid #d9dee3;
        border-radius: 4px;
        padding: 12px;
    }
    .emr-block-title {
        font-size: 0.82rem;
        font-weight: 700;
        color: #495057;
        padding-bottom: 7px;
        margin-bottom: 10px;
        border-bottom: 1px solid #edf0f2;
    }
    .emr-meta-grid {
        display: grid;
        grid-template-columns: repeat(4, minmax(0, 1fr));
        gap: 8px;
        font-size: 0.82rem;
    }
    .emr-meta-item {
        min-height: 44px;
        border: 1px solid #edf0f2;
        background: #fbfcfd;
        padding: 7px 9px;
    }
    .emr-meta-label {
        display: block;
        color: #868e96;
        font-size: 0.72rem;
        margin-bottom: 3px;
    }
    .soap-grid {
        display: grid;
        grid-template-columns: repeat(2, minmax(0, 1fr));
        gap: 12px;
        min-height: 0;
    }
    .soap-column {
        display: flex;
        flex-direction: column;
        gap: 12px;
        min-height: 0;
    }
    .emr-field-label {
        font-size: 0.76rem;
        color: #6c757d;
        font-weight: 600;
        margin-bottom: 4px;
    }
    .emr-actions {
        background: #fff;
        border-top: 1px solid #dee2e6;
        padding-top: 12px;
    }
</style>

<div class="d-flex" style="width: 100vw;">
    
    <%-- ===== 사이드바 (대기 명단) ===== --%>
    <div class="sidebar">
        <div class="sidebar-header">
             대기 환자 목록 (<%= waitingList != null ? waitingList.size() : 0 %>명)
        </div>
        
        <% if (waitingList == null || waitingList.isEmpty()) { %>
            <div class="p-3 text-center text-muted">대기 환자가 없습니다.</div>
        <% } else { %>
            <% for (WaitingBean w : waitingList) { 
                String isActive = (currentPatient != null && w.getPatientId().equals(currentPatient.getPatientId())) ? "active" : "";
            %>
            <a href="Doctor.jsp?selectId=<%= w.getPatientId() %>" class="waiting-item <%= isActive %>">
                <div class="d-flex justify-content-between align-items-center">
                    <strong><%= w.getPatientName() %></strong>
                    <span class="badge bg-<%= "진료중".equals(w.getState()) ? "success" : "secondary" %>"><%= w.getState() %></span>
                </div>
                <div class="small text-muted mt-1">
                    <%= w.getBirth() %> | <%= w.getGender() %>
                </div>
            </a>
            <% } %>
        <% } %>
    </div>

    <%-- ===== 메인 콘텐츠 (좌: 과거기록/예약, 우: EMR 폼) ===== --%>
    <div class="content-area w-100" style="background-color: #f5f6fa;">
        <div class="row h-100 g-3 m-0 w-100">
            
            <%-- 1. 왼쪽 컨테이너 (과거 진료기록 & 과거 예약내역) --%>
            <div class="col-md-3 d-flex flex-column h-100 gap-3 px-0">
                
                <%-- 1-1. 상단: 과거 진료 기록 --%>
                <div class="panel-box" style="flex: 1; min-height: 0;">
                    <div class="emr-header bg-light">
                        <span>📋 과거 진료 기록</span>
                    </div>
                    
                    <div class="p-2" style="flex: 1; overflow-y: auto;">
                        <% if (historyList != null && !historyList.isEmpty()) { %>
                            <% for (HistoryBean h : historyList) { %>
                            <div class="card mb-2 border rounded-1 history-card-item" style="cursor: pointer; font-size: 0.8rem;"
                                 onclick="loadHistoryToForm(this)"
                                 data-id="<%= h.getId() %>"
                                 data-chief-complaint="<%= h.getChiefComplaint() != null ? h.getChiefComplaint() : h.getSymptomDetail() %>"
                                 data-present-illness="<%= h.getPresentIllness() != null ? h.getPresentIllness() : "" %>"
                                 data-past-history="<%= h.getPastHistory() != null ? h.getPastHistory() : "" %>"
                                 data-lab-results="<%= h.getLabResults() != null ? h.getLabResults() : "" %>"
                                 data-imaging-results="<%= h.getImagingResults() != null ? h.getImagingResults() : "" %>"
                                 data-diagnosis="<%= h.getDiagnosis() != null ? h.getDiagnosis() : "" %>"
                                 data-plan="<%= h.getPlan() != null ? h.getPlan() : h.getMemo() %>"
                                 data-free-text="<%= h.getFreeText() != null ? h.getFreeText() : "" %>"
                                 data-bpsys="<%= h.getBpSystolic() %>" data-bpdia="<%= h.getBpDiastolic() %>"
                                 data-temp="<%= h.getTemp() %>" data-weight="<%= h.getWeight() %>" data-height="<%= h.getHeight() %>"
                                 data-hr="<%= h.getHr() != null ? h.getHr() : "" %>" data-rr="<%= h.getRr() != null ? h.getRr() : "" %>"
                                 data-spo2="<%= h.getSpo2() != null ? h.getSpo2() : "" %>">
                                
                                <div class="card-header py-1 px-2 d-flex flex-column bg-light">
                                    <% java.text.SimpleDateFormat historyDateFormat = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm"); %>
                                    <strong class="text-primary mb-1">작성: <%= historyDateFormat.format(h.getEntryDate()) %></strong>
                                    <% if (h.getUpdatedAt() != null) { %>
                                        <span class="text-warning mb-1" style="font-size: 0.72rem;">수정: <%= historyDateFormat.format(h.getUpdatedAt()) %></span>
                                    <% } else { %>
                                        <span class="text-muted mb-1" style="font-size: 0.72rem;">수정: -</span>
                                    <% } %>
                                    <span class="badge bg-secondary align-self-start" style="font-size: 0.7rem; font-weight: normal;">Dr. <%= h.getEmployeeId() %></span>
                                </div>
                                <div class="card-body py-2 px-2">
                                    <div class="text-truncate mb-0" style="max-width: 100%;"><span class="text-danger fw-bold">CC)</span> <%= h.getChiefComplaint() != null ? h.getChiefComplaint() : h.getSymptomDetail() %></div>
                                </div>
                            </div>
                            <% } %>
                        <% } else { %>
                            <div class="text-center text-muted mt-4 small">기록 없음</div>
                        <% } %>
                    </div>
                </div>

                <%-- 1-2. 하단: 과거 예약 기록 --%>
                <div class="panel-box" style="flex: 1; min-height: 0;">
                    <div class="emr-header bg-light">
                        <span>📅 과거 예약 내역</span>
                    </div>
                    
                    <div class="p-2" style="flex: 1; overflow-y: auto;">
                        <% if (apptList != null && !apptList.isEmpty()) { %>
                            <% for (AppointmentBean a : apptList) { %>
                            <div class="card mb-2 border rounded-1 bg-white" style="font-size: 0.8rem;">
                                <div class="card-header py-1 px-2 d-flex flex-column bg-white border-bottom-0">
                                    <div class="d-flex justify-content-between mb-1">
                                        <strong class="text-info"><%= a.getTime() %></strong>
                                        <% String stColor = "취소".equals(a.getState()) ? "danger" : "예약".equals(a.getState()) ? "primary" : "secondary"; %>
                                        <span class="badge bg-<%= stColor %>" style="font-size: 0.7rem;"><%= a.getState() %></span>
                                    </div>
                                    <span class="text-muted" style="font-size: 0.75rem;">
                                        <span class="badge border text-dark me-1" style="background:#f8f9fa;"><%= a.getType() %></span>
                                        Dr. <%= a.getDoctor() == null ? "미지정" : a.getDoctor() %>
                                    </span>
                                </div>
                            </div>
                            <% } %>
                        <% } else { %>
                            <div class="text-center text-muted mt-4 small">예약 기록 없음</div>
                        <% } %>
                    </div>
                </div>

            </div>

            <%-- 2. 오른쪽 컨테이너 (EMR 작성 폼) --%>
            <div class="col-md-9 h-100 pe-0">
                <div class="panel-box h-100 d-flex flex-column">
                    
                    <div class="emr-header">
                        <span>
                            <span class="text-primary">📝 진료 기록 작성</span> 
                            <% if(currentPatient != null) { %>
                                <span class="mx-2">|</span> 
                                <strong><%= currentPatient.getPatientName() %></strong> 
                                <span class="text-muted small">(<%= currentPatient.getGender() %> / <%= currentPatient.getBirth() %>)</span>
                            <% } %>
                        </span>
                        <% if(currentPatient != null) { %>
                            <button type="button" class="btn btn-sm btn-outline-secondary py-0" onclick="resetForm()" style="font-size: 0.8rem;">🔄 신규작성</button>
                        <% } %>
                    </div>

                    <form id="recordForm" class="emr-chart-body">
                        <input type="hidden" name="patient_id" value="<%= (currentPatient != null) ? currentPatient.getPatientId() : "" %>">
                        <input type="hidden" name="history_id" id="history_id">

                        <div class="emr-block">
                            <div class="emr-block-title">진료 기본정보</div>
                            <div class="emr-meta-grid">
                                <div class="emr-meta-item">
                                    <span class="emr-meta-label">환자 ID</span>
                                    <strong><%= currentPatient != null ? currentPatient.getPatientId() : "-" %></strong>
                                </div>
                                <div class="emr-meta-item">
                                    <span class="emr-meta-label">환자명</span>
                                    <strong><%= currentPatient != null ? currentPatient.getPatientName() : "-" %></strong>
                                </div>
                                <div class="emr-meta-item">
                                    <span class="emr-meta-label">성별 / 생년월일</span>
                                    <strong><%= currentPatient != null ? currentPatient.getGender() + " / " + currentPatient.getBirth() : "-" %></strong>
                                </div>
                                <div class="emr-meta-item">
                                    <span class="emr-meta-label">작성자</span>
                                    <strong><%= userName != null ? userName : "Unknown" %></strong>
                                </div>
                            </div>
                        </div>

                        <div class="emr-block">
                            <div class="emr-block-title">Vitals</div>
                            <div class="row g-2">
                                <div class="col-md-2">
                                    <div class="input-group input-group-sm"><span class="input-group-text">Height</span><input type="text" name="height" id="height" class="form-control emr-input" placeholder="cm"></div>
                                </div>
                                <div class="col-md-2">
                                    <div class="input-group input-group-sm"><span class="input-group-text">Weight</span><input type="text" name="weight" id="weight" class="form-control emr-input" placeholder="kg"></div>
                                </div>
                                <div class="col-md-3">
                                    <div class="input-group input-group-sm"><span class="input-group-text">BP</span><input type="text" name="bp_systolic" id="bp_systolic" class="form-control emr-input text-center" placeholder="120"><span class="input-group-text px-1">/</span><input type="text" name="bp_diastolic" id="bp_diastolic" class="form-control emr-input text-center" placeholder="80"></div>
                                </div>
                                <div class="col-md-2">
                                    <div class="input-group input-group-sm"><span class="input-group-text">Temp</span><input type="text" name="temp" id="temp" class="form-control emr-input" placeholder="C"></div>
                                </div>
                                <div class="col-md-1">
                                    <input type="text" name="hr" id="hr" class="form-control form-control-sm emr-input" placeholder="HR">
                                </div>
                                <div class="col-md-1">
                                    <input type="text" name="rr" id="rr" class="form-control form-control-sm emr-input" placeholder="RR">
                                </div>
                                <div class="col-md-1">
                                    <input type="text" name="spo2" id="spo2" class="form-control form-control-sm emr-input" placeholder="SpO2">
                                </div>
                            </div>
                        </div>

                        <div class="soap-grid">
                            <div class="soap-column">
                                <div class="emr-block h-100 d-flex flex-column">
                                    <div class="emr-block-title">S. Subjective</div>
                                    <label class="emr-field-label" for="chief_complaint">Chief Complaint</label>
                                    <textarea id="chief_complaint" name="chief_complaint" class="form-control emr-input mb-2" rows="3" placeholder="주호소"></textarea>
                                    <label class="emr-field-label" for="present_illness">Present Illness</label>
                                    <textarea id="present_illness" name="present_illness" class="form-control emr-input mb-2" rows="4" placeholder="현병력"></textarea>
                                    <label class="emr-field-label" for="past_history">Past History</label>
                                    <textarea id="past_history" name="past_history" class="form-control emr-input flex-grow-1" rows="3" placeholder="과거력, 약물력, 알레르기"></textarea>
                                </div>
                            </div>

                            <div class="soap-column">
                                <div class="emr-block">
                                    <div class="emr-block-title">O. Objective</div>
                                    <label class="emr-field-label" for="lab_results">Lab Results</label>
                                    <textarea id="lab_results" name="lab_results" class="form-control emr-input mb-2" rows="3" placeholder="혈액검사, 소변검사 등"></textarea>
                                    <label class="emr-field-label" for="imaging_results">Imaging / Study Results</label>
                                    <textarea id="imaging_results" name="imaging_results" class="form-control emr-input" rows="3" placeholder="영상판독, 심전도, 기타 검사"></textarea>
                                </div>

                                <div class="emr-block flex-grow-1 d-flex flex-column">
                                    <div class="emr-block-title">A/P. Assessment & Plan</div>
                                    <label class="emr-field-label" for="diagnosis">Assessment</label>
                                    <input type="text" name="diagnosis" id="diagnosis" class="form-control emr-input mb-2" placeholder="추정 진단명">
                                    <label class="emr-field-label" for="plan">Plan</label>
                                    <textarea id="plan" name="plan" class="form-control emr-input mb-2 flex-grow-1" rows="4" placeholder="처방, 검사 계획, 추적 관찰"></textarea>
                                    <label class="emr-field-label" for="free_text">Free Text</label>
                                    <textarea id="free_text" name="free_text" class="form-control emr-input" rows="2" placeholder="기타 메모"></textarea>
                                </div>
                            </div>
                        </div>
                        
                        <div class="alert alert-light border mb-0 py-2" id="voiceStatus" style="display: none; font-size: 0.82rem;">
                            음성 작성 대기 중
                        </div>

                        <div class="d-flex justify-content-end gap-2 emr-actions">
	                        <button type="button" class="btn btn-secondary btn-sm px-3" onclick="resetForm()">초기화</button>
	                        <button type="button" id="voiceBtn" class="btn btn-info btn-sm px-3 text-white" onclick="startVoiceDictation()">🎙 음성 작성</button>
	                        <button type="button" id="saveBtn" class="btn btn-primary btn-sm px-4 fw-bold">진료 완료 및 저장</button>
                        </div>
                    </form>

                </div>
            </div>

        </div> 
    </div> 
</div> 

<script>
    function onPatientClick(patientId) {
        location.href = "Doctor.jsp?selectId=" + patientId;
    }

    // 과거 기록 불러오기 (우측 폼에 데이터 바인딩)
    function loadHistoryToForm(element) {
        var $el = $(element);
        $("#history_id").val($el.data("id"));
        
        $("#chief_complaint").val($el.data("chiefComplaint"));
        $("#present_illness").val($el.data("presentIllness"));
        $("#past_history").val($el.data("pastHistory"));
        $("#lab_results").val($el.data("labResults"));
        $("#imaging_results").val($el.data("imagingResults"));
        $("#diagnosis").val($el.data("diagnosis"));
        $("#plan").val($el.data("plan"));
        $("#free_text").val($el.data("freeText"));
        
        $("#height").val($el.data("height"));
        $("#weight").val($el.data("weight"));
        $("#bp_systolic").val($el.data("bpsys"));
        $("#bp_diastolic").val($el.data("bpdia"));
        $("#temp").val($el.data("temp"));
        $("#hr").val($el.data("hr"));
        $("#rr").val($el.data("rr"));
        $("#spo2").val($el.data("spo2"));

        $("#saveBtn").text("수정 내용 저장").removeClass("btn-primary").addClass("btn-warning text-white");
        $(".history-card-item").removeClass("bg-primary bg-opacity-10 border-primary"); 
        $el.addClass("bg-primary bg-opacity-10 border-primary"); 
    }

    // 폼 초기화
    function resetForm() {
        $("#recordForm")[0].reset();
        $("#history_id").val("");
        $("input[name='patient_id']").val("<%= (currentPatient != null) ? currentPatient.getPatientId() : "" %>");
        $("#voiceStatus").hide();
        
        $("#saveBtn").text("진료 완료 및 저장").removeClass("btn-warning text-white").addClass("btn-primary");
        $(".history-card-item").removeClass("bg-primary bg-opacity-10 border-primary");
    }
    
    var voiceRecognition = null;
    var voiceIsRecording = false;
    var voiceTarget = null;
    var voiceTranscriptBuffer = [];

    function startVoiceDictation() {
        var SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition;
        if (!SpeechRecognition) {
            alert("현재 브라우저에서 음성 작성 기능을 지원하지 않습니다.");
            return;
        }

        if (voiceIsRecording && voiceRecognition) {
            finishVoiceDictation();
            return;
        }

        var patientId = $("input[name='patient_id']").val();
        if (!patientId) {
            alert("환자를 먼저 선택해주세요.");
            return;
        }

        var active = document.activeElement;
        voiceTarget = ($(active).is("#recordForm textarea, #recordForm input[type='text']")) ? active : document.getElementById("chief_complaint");
        voiceTarget.focus();
        voiceTranscriptBuffer = [];
        voiceIsRecording = true;

        voiceRecognition = new SpeechRecognition();
        voiceRecognition.lang = "ko-KR";
        voiceRecognition.interimResults = false;
        voiceRecognition.continuous = true;

        $("#voiceStatus").removeClass("alert-danger alert-success").addClass("alert-info").text("음성 작성 중입니다. '음성 진단 종료' 또는 '종료'라고 말하면 VoiceEMR.json으로 저장됩니다.").show();
        $("#voiceBtn").prop("disabled", false).text("음성 종료");

        voiceRecognition.onresult = function(event) {
            for (var i = event.resultIndex; i < event.results.length; i++) {
                if (!event.results[i].isFinal) {
                    continue;
                }

                var transcript = event.results[i][0].transcript.trim();
                var shouldFinish = transcript.indexOf("음성 진단 종료") >= 0 || transcript === "종료" || transcript.indexOf(" 종료") >= 0;
                var cleaned = transcript.replace(/음성\s*진단\s*종료/g, "").replace(/종료/g, "").trim();

                if (cleaned) {
                    appendVoiceText(cleaned);
                }

                if (shouldFinish) {
                    finishVoiceDictation();
                    return;
                }
            }
        };

        voiceRecognition.onerror = function(event) {
            voiceIsRecording = false;
            $("#voiceStatus").removeClass("alert-info alert-success").addClass("alert-danger").text("음성 인식 오류: " + event.error);
            $("#voiceBtn").prop("disabled", false).text("🎙 음성 작성");
        };

        voiceRecognition.onend = function() {
            if (voiceIsRecording) {
                try {
                    voiceRecognition.start();
                } catch (e) {
                    voiceIsRecording = false;
                    $("#voiceBtn").prop("disabled", false).text("🎙 음성 작성");
                }
            }
        };

        voiceRecognition.start();
    }

    function appendVoiceText(text) {
        if (!text || !voiceTarget) {
            return;
        }

        var current = $(voiceTarget).val();
        var separator = current && !current.endsWith("\n") ? "\n" : "";
        $(voiceTarget).val(current + separator + text);
        voiceTranscriptBuffer.push(text);
        $("#voiceStatus").removeClass("alert-danger alert-success").addClass("alert-info").text("음성 작성 중: " + text);
    }

    function finishVoiceDictation() {
        voiceIsRecording = false;
        $("#voiceBtn").prop("disabled", true).text("저장 중...");

        if (voiceRecognition) {
            try {
                voiceRecognition.stop();
            } catch (e) {
            }
        }

        saveVoiceEmrDraft();
    }

    function saveVoiceEmrDraft() {
        var patientId = $("input[name='patient_id']").val();
        var transcript = voiceTranscriptBuffer.join("\n").trim();

        if (!transcript) {
            $("#voiceStatus").removeClass("alert-info alert-success").addClass("alert-danger").text("저장할 음성 텍스트가 없습니다.");
            $("#voiceBtn").prop("disabled", false).text("🎙 음성 작성");
            return;
        }

        $.ajax({
            url: "ajax/saveVoiceEmr.jsp",
            type: "POST",
            dataType: "json",
            data: {
                patient_id: patientId,
                transcript: transcript
            },
            success: function(response) {
                if (response.success) {
                    $("#voiceStatus").removeClass("alert-info alert-danger").addClass("alert-success").text("VoiceEMR.json 저장 완료: " + response.path);
                } else {
                    $("#voiceStatus").removeClass("alert-info alert-success").addClass("alert-danger").text(response.message || "VoiceEMR.json 저장 실패");
                }
            },
            error: function() {
                $("#voiceStatus").removeClass("alert-info alert-success").addClass("alert-danger").text("VoiceEMR.json 저장 중 서버 오류가 발생했습니다.");
            },
            complete: function() {
                $("#voiceBtn").prop("disabled", false).text("🎙 음성 작성");
            }
        });
    }

    // 진료 저장
    $(document).ready(function() {
        $("#saveBtn").click(function() {
            if ($("input[name='patient_id']").val() == "") {
                alert("환자를 선택해주세요.");
                return;
            }
            $.ajax({
                type: "POST",
                url: "ajax/saveDiagnosis.jsp",
                data: $("#recordForm").serialize(),
                dataType: "json",
                success: function(res) {
                    if (res.success) {
                        alert(res.message);
                        location.reload(); 
                    } else {
                        alert("오류: " + res.message);
                    }
                },
                error: function() { alert("서버 통신 오류"); }
            });
        });
    });
</script>

</body>
</html>
