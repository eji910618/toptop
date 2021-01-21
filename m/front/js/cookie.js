function setCookie(name, value, expires, domain) {
    var resultDomain = '';
    if(domain) {
        resultDomain = domain;
    } else {
        resultDomain = document.domain;
    }

    name = name.replaceAll("\r", "").replaceAll("\n", "");
    value = value.replaceAll("\r", "").replaceAll("\n", "");
    var cookie = name + "=" + escape (value) + "; domain=" + resultDomain + "; path=/";
    if(expires) {
        cookie += "; expires=" + expires.toGMTString();
    }
    document.cookie = cookie;
}

function getCookie(Name) {
    var search = Name + "=";
    if (document.cookie.length > 0) { // 쿠키가 설정되어 있다면
        offset = document.cookie.indexOf(search);
        if (offset != -1) { // 쿠키가 존재하면
            offset += search.length;
            // set index of beginning of value
            end = document.cookie.indexOf(";", offset);
            // 쿠키 값의 마지막 위치 인덱스 번호 설정
            if (end == -1)
                end = document.cookie.length;

            return unescape(document.cookie.substring(offset, end));
        }
    }
    return "";
}