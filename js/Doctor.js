$(document).ready(function () {
  loadWaitingList();

  // 대기 환자 목록 불러오기
  function loadWaitingList() {
    $.getJSON("ajax/getWaitingList.jsp", function (data) {
      let html = "";
      if (data.length === 0) {
        html = "<p class='empty'>현재 대기 중인 환자가 없습니다.</p>";
      } else {
        data.forEach(d => {
          html += `<div class='patient-item' data-id='${d.id}'>
                    <strong>${d.name}</strong> (${d.gender})<br>
                    <small>${d.birth}</small>
                   </div>`;
        });
      }
      $("#waitingList").html(html);
    });
  }

  // 환자 클릭 → 진료 기록 가져오기
  $(document).on("click", ".patient-item", function () {
    const pid = $(this).data("id");
    $.getJSON("ajax/getHistoryList.jsp", { patientId: pid }, function (data) {
      let html = "";
      if (data.length === 0) {
        html = "<p class='empty'>과거 진료 기록이 없습니다.</p>";
      } else {
        data.forEach(h => {
          html += `<div class='history-item'>
                     <strong>${h.date}</strong> [${h.dept}]<br>
                     ${h.memo}
                   </div>`;
        });
      }
      $("#historyList").html(html);
    });
  });

  // 진료 기록 저장
  $("#saveBtn").click(function () {
    $.post("ajax/saveDiagnosis.jsp", $("#recordForm").serialize(), function (res) {
      alert("저장 완료!");
    });
  });
});
