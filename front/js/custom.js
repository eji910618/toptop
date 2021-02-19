'use strict';

/**
 * 각종 초기화 및 함수 추가/재정의
 */

String.prototype.string = function(len){var s = '', i = 0; while (i++ < len) { s += this; } return s;};
String.prototype.df = function(len){return "0".string(len - this.length) + this;};
Number.prototype.df = function(len){return this.toString().df(len);};

String.prototype.isEmpty = function() {
    return this.length < 1 ? !0 : !1
}, String.prototype.replaceAll = function(a, b) {
    return this.replace(new RegExp(a, "gm"), b)
}, String.prototype.getFunction = function() {
    if (this.length < 1) return null;
    for (var a = window, b = this.split("."), c = b.length, d = 0; c - 1 > d; d++)
        if (a = a[b[d]], void 0 == a) return null;
    return a[b[b.length - 1]]
}, String.prototype.getCommaNumber = function() {
    var a = this + "";
    a = a.replace(/[^\+\-0-9.]/g, "");
    var b = /(^[+-]?\d+)(\d{3})/;
    while (b.test(a)) a = a.replace(b, "$1,$2");
    return a
}, Number.prototype.getCommaNumber = function() {
    var a = this + "";
    return a.getCommaNumber()
};

/**
 * <pre>
 * 함수명 : format
 * 설  명 : Date 객체에 format 함수 추가 정의
 * 사용법 : new Date().format('yyyy-mm-dd')
 * 작성일 : 2016. 4. 28.
 * 작성자 : minjae
 * 수정내역(수정일 수정자 - 수정내용)
 * -------------------------------------
 * 2016. 4. 28. minjae - 최초 생성
 * </pre>
 * @param f 출력할 포멧 문자열
 * @return {String} Date 객체의 데이터가 포메팅된 문자열
 */
Date.prototype.format = function(f) {
    if (!this.valueOf()) return "";
    var weekName = ["일요일", "월요일", "화요일", "수요일", "목요일", "금요일", "토요일"];
    var d = this,
    h;
    return f.replace(/(yyyy|yy|MM|dd|E|hh|mm|ss|a\/p)/gi, function($1) {
        switch ($1) {
            case "yyyy": return d.getFullYear();
            case "yy": return (d.getFullYear() % 1000).df(2);
            case "MM": return (d.getMonth() + 1).df(2);
            case "dd": return d.getDate().df(2);
            case "E": return weekName[d.getDay()];
            case "HH": return d.getHours().df(2);
            case "hh": return ((h = d.getHours() % 12) ? h : 12).df(2);
            case "mm": return d.getMinutes().df(2);
            case "ss": return d.getSeconds().df(2);
            case "a/p": return d.getHours() < 12 ? "오전" : "오후";
            default: return $1;
        }
    });
};
/**
 * <pre>
 * 함수명 : trim
 * 설  명 : String 객체에 trim 함수 추가 정의
 * 사용법 : "가나다라 ".trim()
 * 작성일 : 2016. 4. 28.
 * 작성자 : minjae
 * 수정내역(수정일 수정자 - 수정내용)
 * -------------------------------------
 * 2016. 4. 28. minjae - 최초 생성
 * </pre>
 * @param str
 * @returns {string} 앞뒤 공백이 제거된 문자열
 */
String.prototype.trim = function(str) {
    str = this != window ? this : str;
    return str.replace(/^\s+/g,'').replace(/\s+$/g,'');
};

/**
 * jQuery AJAX 초기 설정
 */
//jQuery.ajaxSetup({
//fail: function(xhr,st,err) {
// if (xhr.status == 403) {
//     LayerUtil.confirm('로그인 정보가 없거나 유효시간이 지났습니다.<br/>로그인페이지로 이동하시겠습니까?',
//         function() {
//             document.location.href = '/admin/login/loginView.do';
//         });
// } else {
//     if(xhr.responseJSON && xhr.responseJSON.message) {
//         LayerUtil.alert(xhr.responseJSON.message);
//     } else {
//         LayerUtil.alert("처리중 오류가 발생했습니다. 관리자에게 문의하십시오.");
//     }
// }
// return xhr.responseJSON;
// },
// always: function() {
// waiting.stop();
// }
//});

jQuery(document).ready(function() {
    /**
     * CSRF 공격 방지 설정 및 jQuery ajax 초기화
     */
    Storm.init.ajax();

    /**
     * jQueryUI 달력 초기화
     */
    $( "#datepicker1, #datepicker2" ).datepicker({
        showOn: "button",
        buttonImage: "/front/img/ziozia/common/btn_datepicker.gif",
        buttonImageOnly: true,
        buttonText: "Select date",
        dateFormat: 'yy-mm-dd',
        prevText: '이전 달',
        nextText: '다음 달',
        monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
        monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
        dayNames: ['일','월','화','수','목','금','토'],
        dayNamesShort: ['일','월','화','수','목','금','토'],
        dayNamesMin: ['일','월','화','수','목','금','토'],
        showMonthAfterYear: true,
        changeMonth: true,
        changeYear: true,
        yearSuffix: '년'
    });
});

/**
 * 간단한 템플릿을 구현하기 위한 클래스
 * template 에 Map 형태인 obj의 데이터를 매핑
 * obj 의 KEY에 해당하는 템플릿의 {{KEY}} 문자열이 obj의 VALUE로 치환됨
 *
 * @param template 템플릿 문자열 ex) <span>{{name}}</span>
 * @param obj map 형태의 데이터 객체 ex) {name : 'storm'}
 * @constructor template(필수), obj
 */
Storm.Template = function(template, obj) {
    var srcTemplate = template || '',
    map = obj || {};

    /**
     * 정의된 템플릿에 obj의 데이터를 매핑하여 반환
     * @param obj map 형태의 데이터 객체 ex) {name : 'storm', since: 2016}
     * @returns {*|string}
     */
    this.render = function(obj) {
        var obj = obj || map,
        key,
        exp,
        temp = srcTemplate;

        for(key in obj) {
            exp = new RegExp('{{' + key + '}}', 'gi');
            temp = temp.replace(exp, Storm.validation.isEmpty(obj[key]) ? '' : jQuery.trim(obj[key]));
        }
        return temp;
    };
};

/**
 * 디자인 체크박스 클래스
 */
Storm.CheckboxUtil = {
        /**
         * <pre>
         * 함수명 : check
         * 설  명 : 디자인 체크박스 내부의 체크박스에 값을 설정
         * 사용법 :
         * 작성일 : 2016. 4. 28.
         * 작성자 : minjae
         * 수정내역(수정일 수정자 - 수정내용)
         * -------------------------------------
         * 2016. 4. 28. minjae - 최초 생성
         * </pre>
         * @param obj 이벤트가 발생한 엘리먼트
         * @param checked 체크여부
         */
        check : function(obj, checked) {
            var $this = $(obj),
            $checkbox = $this.find('input');
            if(checked) {
                $this.addClass('on');
                $checkbox.prop('checked', true);
            } else {
                $this.removeClass('on');
                $checkbox.prop('checked', false);
            }
        }
};

/**
 * 디자인 셀렉트 클래스
 */
Storm.SelectUtil = {
    /**
     * <pre>
     * 함수명 : reset
     * 설  명 : 디자인 셀렉트 이전 값으로 되돌린다.
     * 사용법 :
     * 작성일 : 2016. 6. 14.
     * 작성자 : minjae
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------
     * 2016. 6. 14. minjae - 최초 생성
     * </pre>
     * @param obj 되돌릴 값의 SELECT 엘리먼트
     */
    reset : function(obj) {
        var $this = $(obj),
            select_name;
        $this.find('option[value="' + $this.data('prevValue') + '"]').prop('selected', true);
        select_name = $this.children('option:selected').text();
        $this.siblings('label').text(select_name);
    }
};

/**
 * 초기화에 관련된 클래스
 */
Storm.init = {
    /**
     * <pre>
     * 함수명 : jQuery ajax의 요청/오류반환/완료 시에 대한 공통 처리 초기화
     * 설  명 :
     * 사용법 :
     * 작성일 : 2016. 4. 28.
     * 작성자 : minjae
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------
     * 2016. 4. 28. minjae - 최초 생성
     * </pre>
     */
    ajax : function() {
        var token = $("meta[name='_csrf']").attr("content"),
        header = $("meta[name='_csrf_header']").attr("content");

        $(document).ajaxSend(function(e, xhr, options) {
            //Storm.waiting.start();
            xhr.setRequestHeader(header, token);
        });
        $(document).ajaxError(function(e, xhr, options) {
            if(options.url.indexOf('www-ssts.topten10mall.com') == -1){ //accesslog insert cors ajax는 에러나도 무시함
                if (xhr.status == 403) {
                    Storm.LayerUtil.confirm('로그인 정보가 없거나 유효시간이 지났습니다.<br/>로그인페이지로 이동하시겠습니까?',
                            function() {
                        document.location.href = '/front/login/viewLogin.do';
                    });
                } else {
                    if (xhr.responseJSON && xhr.responseJSON.message) {
                        console.log(xhr.responseJSON.message);
                        Storm.LayerUtil.alert(xhr.responseJSON.message);
                    } else {
                        Storm.LayerUtil.alert("처리중 오류가 발생했습니다. 관리자에게 문의하십시오.");
                    }
                }
            }
        });
        $(document).ajaxComplete(function(e, xhr, options) {
            // Storm.waiting.stop();

            return xhr.responseJSON;
        });

    },
    /**
     * <pre>
     * 함수명 : datePeriodButton
     * 설  명 : 달력 옆에 달린 기간 버튼에 대한 이벤트 처리 및 설정
     * 사용법 :
     * 작성일 : 2016. 6. 1.
     * 작성자 : KMS
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------
     * 2016. 6. 1. KMS - 최초 생성
     * </pre>
     */
    datePeriodButton : function() {
        /**
         * 달력 버튼 클릭시 이벤트 처리
         */
        $('.date_select_area .btn_date_select').on('click', function(e){
            Storm.EventUtil.stopAnchorAction(e);

            $(this).addClass('active').siblings().removeClass('active');

            //TODO: 클릭시 달력 데이터 변경
            var $this = jQuery(this),
            index = $this.index(),
            $to = $('#datepicker2'),
            $from = $('#datepicker1'),
            date,
            from,
            to = $to.val();
            if(jQuery.trim(to) == '') {
                date = new Date();
                to = date.format('yyyy-MM-dd');
            } else {
                date = new Date($to.val().replace(/-/g, '/'));
            }

            // TODO: 올바르지 않은 문자일때 오류처리
            switch (index) {
                case 0 :
                    date.setMonth(date.getMonth() - 1);
                    break;
                case 1 :
                    date.setMonth(date.getMonth() - 3);
                    break;
                case 2 :
                    date.setMonth(date.getMonth() - 6);
                    break;
                case 3 :
                    date.setMonth(date.getMonth() - 12);
                    break;
                default :
                    from = '';
                    to = '';
                    break;
            }

            if(from != '') {
                from = date.format('yyyy-MM-dd');
            }

            $from.val(from);
            $to.val(to);
            console.log()
        });
    }
};

/**
 * 각종 값을 바인드하는 클래스
 *
 * @type {{setActionTypeUpdate: FormUtil.setActionTypeUpdate, jsonToForm: FormUtil.jsonToForm}}
 */
Storm.FormUtil = {

        /**
         * <pre>
         * 함수명 : getActionTypeObj
         * 설  명 : formId의 해당하는 폼의 액션 타입을 반환하는 함수
         * 사용법 :
         * 작성일 : 2016. 4. 28.
         * 작성자 : minjae
         * 수정내역(수정일 수정자 - 수정내용)
         * -------------------------------------
         * 2016. 4. 28. minjae - 최초 생성
         * </pre>
         * @param formId
         * @return {Object} 액션 타입 input jQuery Object, 없으면 빈값을 가진 input jQuery Object
         */
        getActionTypeObj : function(formId) {
            var $form = jQuery('#' + formId),
            $actionType = $form.find('input[name="_action_type"]');
            if(!$actionType || $actionType.length === 0) {
                $actionType = jQuery('<input type="hidden" name="_action_type" />');
                $form.append($actionType);
            }

            return $actionType;
        },

        /**
         * <pre>
         * 함수명 : setActionTypeUpdate
         * 설  명 : formId 에 해당하는 폼의 액션 타입을 '수정'으로 변경
         * 사용법 :
         * 작성일 : 2016. 4. 28.
         * 작성자 : minjae
         * 수정내역(수정일 수정자 - 수정내용)
         * -------------------------------------
         * 2016. 4. 28. minjae - 최초 생성
         * </pre>
         * @param formId 폼 ID
         */
        setActionTypeUpdate : function(formId) {
            console.log('set action type : UPDATE');
            Storm.FormUtil.getActionTypeObj(formId).val('UPDATE');
        },

        /**
         * <pre>
         * 함수명 : setActionTypeInsert
         * 설  명 : formId 에 해당하는 폼의 액션 타입을 '등록'으로 변경
         * 사용법 :
         * 작성일 : 2016. 4. 28.
         * 작성자 : minjae
         * 수정내역(수정일 수정자 - 수정내용)
         * -------------------------------------
         * 2016. 4. 28. minjae - 최초 생성
         * </pre>
         * @param formId 폼 ID
         */
        setActionTypeInsert : function(formId) {
            console.log('set action type : INSERT');
            Storm.FormUtil.getActionTypeObj(formId).val('INSERT');
        },
        getActionType : function(formId) {
            var actionType = Storm.FormUtil.getActionTypeObj(formId).val();
            console.log('action type : ', actionType|| 'INSERT');
            return actionType || 'INSERT';
        },

        /**
         * <pre>
         * 함수명 : jsonToForm
         * 설  명 : JSON 형태의 데이터를 formId에 해당하는 폼에 바인드
         *          JSON 객체의 KEY의 이름과 같은 INPUT, SELECT, TEXTAREA엘리먼트의 값으로 VALUE를 세팅
         *          없다면 'bind_target_id_[KEY]'에 해당하는 엘리먼트의 'TEXT'로 VALUE를 세팅
         * 사용법 :
         * 작성일 : 2016. 4. 28.
         * 작성자 : minjae
         * 수정내역(수정일 수정자 - 수정내용)
         * -------------------------------------
         * 2016. 4. 28. minjae - 최초 생성
         * </pre>
         * @param json 폼에 매핑할 JSON 객체
         * @param formId 폼 ID
         */
        jsonToForm : function(json, formId) {
            var key,
            value,
            $form = jQuery('#' + formId),
            $obj;

            for(key in json) {
                $obj = $form.find('input[name="' + key + '"], select[name="' + key + '"], textarea[name="' + key + '"]');
                value = json[key] || '';
                console.log(key, value, $obj);

                if($obj.length == 0) {
                    $obj = $form.find('#bind_target_id_' + key);
                    if($obj.length == 0) continue;
                };

                switch ($obj[0].tagName) {
                    case 'INPUT' :
                        switch ($obj.attr('type')) {
                            case 'radio' :
                                var $o = $obj.filter('input[value="' + value + '"]');
                                $o.prop('checked', true);
                                $o.parents('label').addClass('on').siblings().removeClass('on');
                                break;
                            case 'checkbox' :
                                var $o = $obj.filter('input[value="' + value + '"]');
                                $o.prop('checked', true);
                                $o.next().addClass('on').siblings().removeClass('on');
                                break;
                            default :
                                $obj.val(Storm.HtmlUtil.unescape(value));
                        }
                        break;
                    case 'SELECT' :
                        var $o = $obj.find('option[value="' + value + '"]');
                        $o.prop('selected', true);
                        $o.next().addClass('on').siblings().removeClass('on');
                        break;
                    case 'TEXTAREA' :
                    default :
                        $obj.text(Storm.HtmlUtil.unescape(value));
                }
            }

            Storm.FormUtil.setActionTypeUpdate(formId);
        },

        /**
         * <pre>
         * 함수명 : submit
         * 설  명 :
         * 사용법 :
         * 작성일 : 2016. 4. 28.
         * 작성자 : minjae
         * 수정내역(수정일 수정자 - 수정내용)
         * -------------------------------------
         * 2016. 4. 28. minjae - 최초 생성
         * 2016. 5. 16. minjae - target 추가
         * </pre>
         * @param url 서버로 요청할 URL
         * @param paramMap 서버로 요청시 전달할 파라미터 객체(맵형식)
         * @param target from 태그의 target
         * @returns {Boolean} 오류시 false
         */
        submit : function (url, paramMap, target) {
            jQuery('#_form_id_comm').remove();

            var token = $("meta[name='_csrf']").attr("content"),
                $form = jQuery('<form method="post"></form>'),
                inputTemplate = '<input type="hidden" name="{{name}}" value="{{value}}" />',
                template = new Storm.Template(inputTemplate),
                key;

            $form.attr({'action' : url, 'method' : 'post', 'id' : '_form_id_comm'});

            if(target) {
                $form.attr('target', target);
            }

            if(paramMap != null && !$.isPlainObject(paramMap)) {
                Storm.LayerUtil.alert('param 변수가 Object(Map) 형식이 아닙니다.');
                return false;
            }

            $form.append(template.render({name: '_csrf', value : token}));

            for(key in paramMap) {
                //$form.append(template.render({name: key, value : paramMap[key]}));
                $form.append(jQuery('<input type="hidden"/>').attr({
                    name : key,
                    value : paramMap[key]
                }));
            }
            console.log($form.serialize());
            jQuery('body').append($form);
            $form.submit();
        }
};

/**
 * jQuery 플러그인 정의
 */
(function($) {
    /**
     * jQuery 그리드 플러그인
     * 그리드의 페이징 이벤트를 처리
     *
     * @param $form 조회조건 폼 jQuery 객체
     * @param callback 콜백함수 = 조회 함수
     */
    $.fn.grid = function($form, callback) {
        callback = callback || function () {$form.submit();};
        return this.each(function() {
            var $grid = $(this),
            $page = $form.find('input[name="page"]');
            $grid.find('a.strpre, a.pre, a.num:not(.on), a.nex, a.endnex').on('click', function(e) {
                Storm.EventUtil.stopAnchorAction(e);

                $page.val(jQuery(this).data('page'));
                callback();
            });
            $grid.find('select[name="sidx"]').on('change', function() {
                $form.find('input[name="sort"]').val(this.value);
                callback();
            });
            $grid.find('select[name="rows"]').on('change', function() {
                $form.find('input[name="rows"]').val(this.value);
                callback();
            });
        });
    };
})(jQuery),

function($) {
    "use strict";
    $.fn.DataBinder = function(data, target, area, row) {
        return this.each(function() {
            var $obj = $(this);
            // alert(f.data("bind-type"));
            if (null != data && "object" == typeof data) {
                var type = $obj.data("bind-type"), bindName = $obj.data("bind-value");

                if (null != type && ! $.isEmptyObject(type)) {
                    // alert("test 111");
                    if (null == bindName || bindName.length < 1)
                        return void $obj.html("(no bind)");

                    var value = null == data[bindName] ? "" : data[bindName];

                    switch (type.toLowerCase()) {
                        case "function":
                            var func = $obj.data("bind-function");
                            func = null == func || func.isEmpty() ? null : func.getFunction(), null != func && "function" == typeof func ? func.apply(null, [data, $obj, bindName, target, area, row]) : "" ;
                            break;
                        case "radio":
                            $obj.prop("disabled", "disabled"), $obj.val() == value && $obj.prop("checked", "checked");
                            break;
                        case "checkbox":
                            $obj.prop("disabled", "disabled"), $obj.val() == value && $obj.prop("checked", "checked");
                            break;
                        case "text":
                            $obj.val(value);
                            break;
                        case "bizno":
                            $obj.val(Storm.formatter.bizNo(value));
                            break;
                        case "tel":
                            $obj.val(Storm.formatter.tel(value));
                            break;
                        case "fax":
                            $obj.val(Storm.formatter.fax(value));
                            break;
                        case "select":
                            $("option[value='"+ value +"']", $obj).attr("selected", "true");
                            break;

                        case "password":
                            $obj.data("input-value", value).text("".padding(value.length, "*"));
                            break;

                        case "commanumber":
                            $obj.data("value", value).html(parseInt(value).getCommaNumber());
                            break;

                        case "number":
                        case "string":
                        default:
                            $obj.data("value", value).html(value);
                            break;
                    }
                }
            }
        })
    }
}(jQuery);

Storm.HtmlUtil = {
    escape : function(text) {
        var entityMap = {
            "&": "&amp;",
            "<": "&lt;",
            ">": "&gt;",
            '"': '&quot;',
            "'": '&#39;',
            "/": '&#x2F;'
        };

        return String(text).replace(/[&<>"'\/]/g, function (s) {
            return entityMap[s];
        });
    },
    unescape : function(text) {
        var entityMap = {
            '&amp;': '&',
            '&lt;': '<',
            '&gt;': '>',
            '&quot;': '"',
            '&#39;': "'",
            '&#x2F;': '/'
        };
        return String(text).replace(/(&amp;)|(&lt;)|(&gt;)|(&quot;)|(&#39;)|(&#x2F;)/g, function (s) {
            return entityMap[s];
        });
    }
};