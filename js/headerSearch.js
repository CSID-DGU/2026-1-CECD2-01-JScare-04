$(document).ready(function() {
    $("#headerSearchInput").on("keyup", function() {
        let keyword = $(this).val();
        
        if (keyword.length < 1) {
            $("#search-results").hide();
            return;
        }

        $.ajax({
            // [중요] 경로는 아래 header.jsp에서 설정한 변수(contextPath)를 사용합니다.
            url: contextPath + "/ajax/searchPatient.jsp",
            type: "GET",
            data: { keyword: keyword },
            dataType: "json",
            success: function(data) {
                let html = "";
                if (data.length > 0) {
                    $.each(data, function(index, p) {
                        // 이제 순수 자바스크립트 파일이므로 ${}를 편하게 씁니다.
                        html += `<div class="search-item" onclick="location.href='main.jsp?selectId=${p.id}'">
                                    <strong>${p.name}</strong> 
                                    <small>(${p.gender}/${p.birth})</small><br>
                                    <small class="text-muted">ID: ${p.id}</small>
                                 </div>`;
                    });
                    $("#search-results").html(html).show();
                } else {
                    $("#search-results").html("<div class='search-item text-muted'>검색 결과가 없습니다.</div>").show();
                }
            },
            error: function() {
                console.log("검색 실패");
            }
        });
    });

    // 검색창 밖 클릭 시 닫기
    $(document).click(function(e) {
        if (!$(e.target).closest('.search-container').length) {
            $("#search-results").hide();
        }
    });
});