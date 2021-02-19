// 그리드 관련 유틸
Storm.GridUtil = {
    /**
     * <pre>
     * 함수명 : appendPaging
     * 설  명 : 입력받은 조회 데이터와 ID들로 페이징 네이게이션을 생성한다.
     * 사용법 :
     * 작성일 : 2016. 5. 11.
     * 작성자 : minjae
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------
     * 2016. 5. 11. minjae - 최초 생성
     * </pre>
     *
     * @param formId
     *            조회조건이 속한 폼의 ID
     * @param parentId
     *            페이징이 추가될 부모 엘리먼트의 ID
     * @param resultListModel
     *            JSON으로 받은 조회 데이터
     * @param pagingId
     *            생성할 페이징의 ID
     * @param callback
     *            페이징의 페이지 클릭시 실행할 함수(조회 함수)
     */
    appendPaging : function(formId, parentId, resultListModel, pagingId, callback) {
        jQuery('#' + parentId).html(Storm.GridUtil.paging(resultListModel, pagingId));
        if(callback) {
            jQuery('#' + parentId).grid(jQuery('#' + formId), callback);
        } else {
            jQuery('#' + parentId).grid(jQuery('#' + formId));
        }
    },

    /**
     * <pre>
     * 함수명 : paging
     * 설  명 : 입력받은 조회 데이터와 ID로 페이징 네이게이션 코드를 생성한다.
     *          현재는 내부적으로 사용, 외부에서 appendPaging으로 처리가 안될 경우 따로 불러서 처리...
     * 사용법 :
     * 작성일 : 2016. 5. 11.
     * 작성자 : minjae
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------
     * 2016. 5. 11. minjae - 최초 생성
     * </pre>
     *
     * @param resultListModel
     *            JSON으로 받은 조회 데이터
     * @param pagingId
     *            생성할 페이징의 ID
     */
    paging : function(resultListModel, id) {
        var currPageDiv = parseInt(Math.floor((resultListModel.page - 1) / resultListModel.rows), 10) +  1;
        var firstOfPage = parseInt((currPageDiv - 1) * resultListModel.rows, 10) + 1;
        var lastPage = parseInt(Math.min(currPageDiv * resultListModel.rows, resultListModel.totalPages), 10);
        var prevPage = resultListModel.page - 1;
        var nextPage = resultListModel.page + 1;
        var p = '';
		var prevClass, nextClass;
        if(resultListModel.page > 1) {
            prevClass = 'pre';
        } else {
            prevClass = '';
        }
        if(resultListModel.totalPages > resultListModel.page) {
            nextClass = 'nex"';
        } else {
            nextClass = '';
        }

        p += '<li class="img prev"><a href="#none" class="'+prevClass+'" data-page="' + (prevPage) + '">이전</a></li>';

        for(var i = firstOfPage; i <= lastPage; i++) {
            if(resultListModel.page == i){
                p += '<li><a href="#none" class="active">'+i+'</li>';
            }else{
                p += '<li><a href="#none" class="num" data-page="' + i + '">'+i+'</a></li>';
            }
        }
        p += '<li class="img next"><a href="#none" class="'+nextClass+' data-page="' + (nextPage) + '">다음</a></li>';
        return p;
    }
};