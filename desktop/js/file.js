var Storm = Storm || {};


/**
 * 파일 업로드 클래스
 * file, image, excel 함수는 jQuery.Deferred 객체를 반환하므로 done, fail등을 사용가능한다.
 *
 * @type {{file: FileUpload.file, excel: FileUpload.excel, image: FileUpload.image, fileForm: FileUpload.fileForm, upload: FileUpload.upload, checkFileSize: FileUpload.checkFileSize}}
 */
Storm.FileUpload = {
    /**
     * <pre>
     * 함수명 : file
     * 설  명 : 간단 파일 업로드 - 업로드할 파일을 선택하면 바로 업로드
     * 사용법 :
     * 작성일 : 2016. 5. 16.
     * 작성자 : minjae
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------
     * 2016. 5. 16. minjae - 최초 생성
     * </pre>
     * @returns
     */
    file : function() {
        return Storm.FileUpload.fileForm("file");
    },
    /**
     * <pre>
     * 함수명 : excel
     * 설  명 : 간단 엑셀 업로드 - 업로드할 엑셀 파일을 선택하면 바로 업로드
     * 사용법 :
     * 작성일 : 2016. 5. 16.
     * 작성자 : minjae
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------
     * 2016. 5. 16. minjae - 최초 생성
     * </pre>
     * @returns
     */
    excel : function() {
        return Storm.FileUpload.fileForm("xls");
    },
    /**
     * <pre>
     * 함수명 : image
     * 설  명 : 간단 이미지 파일 업로드 - 업로드할 이미지 파일을 선택하면 바로 업로드
     * 사용법 :
     * 작성일 : 2016. 5. 16.
     * 작성자 : minjae
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------
     * 2016. 5. 16. minjae - 최초 생성
     * </pre>
     * @returns
     */
    image : function() {
        return Storm.FileUpload.fileForm("image");
    },
    editor : function() {
        return Storm.FileUpload.fileForm("editor");
    },
    /**
     * <pre>
     * 함수명 : fileForm
     * 설  명 : 간단 파일 업로드를 위한 파일 업로드 폼 생성 및 업로드 처리
     *          다른 함수들에 의해 내부적으로 호출된다.
     * 사용법 :
     * 작성일 : 2016. 5. 16.
     * 작성자 : minjae
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------
     * 2016. 5. 16. minjae - 최초 생성
     * </pre>
     * @returns
     */
    fileForm : function(type) {
        $("#layer_upload_image").remove();
        var html = '',
            url = '/front/common/fileUploadResult.do',
            accept = '',
            title = '파일',
            dfd = jQuery.Deferred();
        switch(type) {
            case  'xls' :
                accept = ' accept="application/vnd.ms-excel, application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"';
                title = '엑셀';
                break;
            case 'editor' :
                url = '/front/common/editorImageUploadResult.do';
                accept = ' accept="image/*"';
                title = '이미지';
                break;
            case 'image' :
                url = '/front/common/imageUploadResult.do';
                accept = ' accept="image/*"';
                title = '이미지';
                break;
            case 'naver' :
                url = '/front/common/naverHtmlFileUploadResult.do';
                accept = ' accept="text/html"';
                title = '네이버 사이트 소유확인 HTML';
                break;
            default :
                break;
        }

        html += '<div id="layer_upload_image" class="slayer_popup">';
        html += '    <div class="pop_wrap size1">';
        html += '        <!-- pop_tlt -->';
        html += '        <div class="pop_tlt">';
        html += '            <h2 class="tlth2">' + title + ' 업로드</h2>';
        html += '            <button id="btn_close_layer_upload_image" class="close ico_comm">닫기</button>';
        html += '        </div>';
        html += '        <!-- //pop_tlt -->';
        html += '        <!-- pop_con -->';
        html += '        <div class="pop_con">';
        html += '            <div>';
        html += '                <form action="' + url + '" name="uploadForm" id="form_id_fileUploadForm" method="post" >';
        html += '                    <span class="br"></span>';
        html += '                    <span class="intxt imgup1"><input id="file_route1" class="upload-name" type="text" value="파일선택" disabled="disabled"></span>';
        html += '                    <label class="filebtn" for="input_id_file">파일찾기</label>';
        html += '                       <input class="filebox" name="file" type="file" id="input_id_file"'+ accept + '>';
        // html += '                    </span>';
        html += '                    <div class="btn_box txtc">';
        html += '                        <button class="btn_green" id="btn_upload">업로드</button>';
        html += '                        <button class="btn_red" id="btn_cancel">취소</button>';
        html += '                    </div>';
        html += '                </form>';
        html += '                ';
        html += '            </div>';
        html += '        </div>';
        html += '        <!-- //pop_con -->';
        html += '    </div>';
        html += '</div>';

        $("body").append(html);
        Storm.LayerPopupUtil.open(jQuery('#layer_upload_image'));

        $(document).on('change', '#input_id_file', function() {
            jQuery('#file_route1').val(this.value);
        });

        $("#btn_cancel").on('click', function(e) {
            Storm.EventUtil.stopAnchorAction(e);
            Storm.LayerPopupUtil.close('layer_upload_image');
        });
        $("#btn_upload")
            .on('click', function(e) {
                Storm.EventUtil.stopAnchorAction(e);

                $('#form_id_fileUploadForm').ajaxSubmit({
                    url : url,
                    dataType : 'json',
                    contentType: "application/json",
                    success : function(result) {
                        Storm.LayerPopupUtil.close('layer_upload_image');
                        if (result.success != undefined && result.success === false) {
                            alert(result.message);
                        } else if(result.exCode != null && result.exCode != undefined && result.exCode != ""){
                            alert(result.message);
                        } else {
                            if(result.files) {
                                dfd.resolve(result);
                            } else {
                                dfd.resolve(jQuery.parseJSON(result));
                            }
                        }
                    }

                    // 파일 업로드 중 에러 발생의 경우 처리 추가(2016.09.26, wtkim)
                    , error : function(result) {
                        Storm.LayerPopupUtil.close('layer_upload_image');
                        if(result && result.message ){
                            alert(result.message);
                        } else {
                            alert('파일 업로드 중 에러가 발생했습니다.');
                            dfd.resolve(result);
                        }
                    }
                });
            });

        return dfd.promise();
    },

    upload : function(formId) {
        var dfd = jQuery.Deferred(),
            $form = $('#' + formId),
            token = $("meta[name='_csrf']").attr("content"),
            header = $("meta[name='_csrf_header']").attr("content"),
            url = $form.attr("action") || '/admin/common/fileUploadResult.do';

        if(url.indexOf(header) < 0) {
            // csrf 토큰 추가
            url += '?' + header + '=' + token;
        }

        $form.ajaxSubmit({
            url : url,
            dataType : 'json',
            success : function(result) {
                if(result.exCode != null && result.exCode != undefined && result.exCode != ""){
                    alert(result.message);
                } else {
                    dfd.resolve(result);
                }
            }
        });

        return dfd.promise();
    },
    checkFileSize : function (formId) {
        var $files = jQuery('#' + formId + ' input[type="file"]'),
            files, file;

        if(document.documentMode && document.documentMode < 10) {
            return true;
        }

        for(var i = 0, len = $files.length; i < len; i++) {
            files = $files[i].files;

            if(files && files.length){
                for(var j = 0, l = files.length; j < l; j++) {
                    file = files[j];

                    // 파일 사이즈 수정 필요
                    if(file.size > Constant.file.maxSize) {
                        Storm.LayerUtil.alert('파일 ' + file.name + '의 파일사이즈가 2MB를 초과합니다.');
                        return false;
                    }
                }
            }
        }
        return true;
    }
};

// 파일다운로드
Storm.FileDownload = {
    /**
     * <pre>
     * 함수명 : download
     * 설  명 : 서버의 파일을 다운로드 한다.
     *
     * 사용법 : StormFileDownload.download('BBS', 1);
     *          StormFileDownload.download('BBS', '201034040', '1');
     *          StormFileDownload.download('BBS', '201034040', 'TOP', 123);
     * 작성일 : 2016. 5. 16.
     * 작성자 : minjae
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------
     * 2016. 5. 16. minjae - 최초 생성
     * </pre>
     * @augments args
     *      첫번째 인자 - 타입
     *      두번째 이후의 인자 - 파일 정보를 조회하기 위한 키값으로 순서대로 id1, id2, id3 값으로 서버로 전달된다.
     * @returns
     */
    download : function(args) {
        var url = '/admin/common/download.do',
            key,
            param = {};
        for(var i = 0; i < arguments.length ; i++) {
            if(i === 0) {
                key = "type";
            } else {
                key = "id" + i;
            }

            param[key] = arguments[i];
        }

        Storm.FormUtil.submit(url, param, '_blank');
    }
};