var SSTS = {};

SSTS.Timer = {
	realTime : false,

    /**
     * timer에 의해 show로 상태전환
     * @param time 실행할 시간
     * @param selector 실행시킬 id 또는 class
     * @param realTime 실시간 반영 여부
     */
    show : function(time, selector, realTime) {
        var endDay = time;
        if(endDay.substring(10,11) == ' '){
        	endDay = endDay.substring(0,10) + "T" + endDay.substring(11);
        }
        if(endDay.substring(19,20) == ''){
        	endDay = endDay + "Z";
        }
        var dDay = new Date(endDay);
        dDay = new Date(dDay.setHours(dDay.getHours()-9));
        var timer = dDay - now;
        var timeSecond = Math.floor(timer/1000);
        var realTime = realTime || SSTS.Timer.realTime;

        if(timeSecond > 0){
        	$(selector).hide();
        }else{
        	$(selector).show();
        	return;
        }

        if(realTime){
        	var interval = setInterval(function(){
        		timeSecond--;
        		if(timeSecond < 0){
        			clearInterval(interval);
        			$(selector).show();
        		}
        	}, 1000);
        }
    },

    /**
     * timer에 의해 hide로 상태전환
     * @param time 실행할 시간
     * @param selector 실행시킬 id 또는 class
     * @param realTime 실시간 반영 여부
     */
    hide : function(time, selector, realTime) {
        var endDay = time;
        if(endDay.substring(10,11) == ' '){
        	endDay = endDay.substring(0,10) + "T" + endDay.substring(11);
        }
        if(endDay.substring(19,20) == ''){
        	endDay = endDay + "Z";
        }
        var dDay = new Date(endDay);
        dDay = new Date(dDay.setHours(dDay.getHours()-9));
        var timer = dDay - now;
        var timeSecond = Math.floor(timer/1000);
        var realTime = realTime || SSTS.Timer.realTime;

        if(timeSecond > 0){
        	$(selector).show();
        }else{
        	$(selector).hide();
        	return;
        }

        if(realTime){
        	var interval = setInterval(function(){
        		timeSecond--;
        		if(timeSecond < 0){
        			clearInterval(interval);
        			$(selector).hide();
        		}
        	}, 1000);
        }
    },

    /**
     * timer에 의해 function 실행
     * @param time 실행할 시간
     * @param myFunc 실행시킬 function
     * @param realTime 실시간 반영 여부
     */
    func : function(time, myFunc, realTime){
    	var endDay = time;
    	if(endDay.substring(10,11) == ' '){
        	endDay = endDay.substring(0,10) + "T" + endDay.substring(11);
        }
    	if(endDay.substring(19,20) == ''){
        	endDay = endDay + "Z";
        }
        var dDay = new Date(endDay);
        dDay = new Date(dDay.setHours(dDay.getHours()-9));
        var timer = dDay - now;
        var timeSecond = Math.floor(timer/1000);
        var realTime = realTime || SSTS.Timer.realTime;

        if(timeSecond > 0){
        }else{
        	myFunc();
        	return;
        }

        if(realTime){
        	var interval = setInterval(function(){
        		timeSecond--;
        		if(timeSecond < 0){
        			clearInterval(interval);
        			myFunc();
        		}
        	}, 1000);
        }
    },

    /**
     * timer에 의해 function 실행
     * @param from 시작 시간
     * @param to 끝나는 시간
     * @param myFunc 실행시킬 function
     * @param realTime 실시간 반영 여부
     */
    fromTo : function(from, to, myFunc, realTime){
    	var startTime = from;
    	if(startTime.substring(10,11) == ' '){
    		startTime = startTime.substring(0,10) + "T" + startTime.substring(11);
        }
    	if(startTime.substring(19,20) == ''){
    		startTime = startTime + "Z";
        }
        var startDay = new Date(startTime);
        startDay = new Date(startDay.setHours(startDay.getHours()-9));
        
        var endTime = to;
        if(endTime.substring(10,11) == ' '){
        	endTime = endTime.substring(0,10) + "T" + endTime.substring(11);
        }
        if(endTime.substring(19,20) == ''){
        	endTime = endTime + "Z";
        }
        var endDay = new Date(endTime);
        endDay = new Date(endDay.setHours(endDay.getHours()-9));

        var startTimer = startDay - now;
        var endTimer = endDay - now;
        var startTimeSecond = Math.floor(startTimer/1000);
        var endTimeSecond = Math.floor(endTimer/1000);

        var realTime = realTime || SSTS.Timer.realTime;

        if(startTimeSecond < 0 && endTimeSecond > 0){
        	myFunc();
        	return;
        }

        if(realTime){
        	var interval = setInterval(function(){
        		startTimeSecond--;
        		endTimeSecond--;
        		if(startTimeSecond < 0 && endTimeSecond > 0){
        			clearInterval(interval);
        			myFunc();
        		}
        	}, 1000);
        }
    }
};

SSTS.Number = {
	    comma : function(num) {
	    	var str = String(num);
	        return str.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');

	    },
	    uncomma : function(num){
	    	var str = String(num);
	        return str.replace(/[^\d]+/g, '');
	    }
}

SSTS.hammer = {
        pinch : function(imgUrl, selector) {
            const imageUrl = imgUrl;
            const imageContainer = document.querySelector(selector);

            var minScale = 1;
            var maxScale = 4;
            var imageWidth;
            var imageHeight;
            var containerWidth;
            var containerHeight;
            var displayImageX = 0;
            var displayImageY = 0;
            var displayImageScale = 1;

            var displayDefaultWidth;
            var displayDefaultHeight;

            var rangeX = 0;
            var rangeMaxX = 0;
            var rangeMinX = 0;

            var rangeY = 0;
            var rangeMaxY = 0;
            var rangeMinY = 0;

            var displayImageRangeY = 0;

            var displayImageCurrentX = 0;
            var displayImageCurrentY = 0;
            var displayImageCurrentScale = 1;


            function resizeContainer() {
              containerWidth = imageContainer.offsetWidth;
              containerHeight = imageContainer.offsetHeight;
              if (displayDefaultWidth !== undefined && displayDefaultHeight !== undefined) {
                displayDefaultWidth = displayImage.offsetWidth;
                displayDefaultHeight = displayImage.offsetHeight;
                updateRange();
                displayImageCurrentX = clamp( displayImageX, rangeMinX, rangeMaxX );
                displayImageCurrentY = clamp( displayImageY, rangeMinY, rangeMaxY );
                updateDisplayImage(
                  displayImageCurrentX,
                  displayImageCurrentY,
                  displayImageCurrentScale );
              }
            }

            resizeContainer();

            function clamp(value, min, max) {
              return Math.min(Math.max(min, value), max);
            }

            function clampScale(newScale) {
              return clamp(newScale, minScale, maxScale);
            }

            window.addEventListener('resize', resizeContainer, true);

            const displayImage = new Image();
            displayImage.src = imageUrl;
            displayImage.onload = function(){
              imageWidth = displayImage.width;
              imageHeight = displayImage.height;
              imageContainer.appendChild(displayImage);
              displayImage.addEventListener('mousedown', function(e){ e.preventDefault(), false});
              displayDefaultWidth = displayImage.offsetWidth;
              displayDefaultHeight = displayImage.offsetHeight;
              rangeX = Math.max(0, displayDefaultWidth - containerWidth);
              rangeY = Math.max(0, displayDefaultHeight - containerHeight);
            }

            imageContainer.addEventListener('wheel', function(e) {
              displayImageScale = displayImageCurrentScale = clampScale(displayImageScale + (e.wheelDelta / 800));
              updateRange();
              displayImageCurrentX = clamp(displayImageCurrentX, rangeMinX, rangeMaxX)
              displayImageCurrentY = clamp(displayImageCurrentY, rangeMinY, rangeMaxY)
                updateDisplayImage(displayImageCurrentX, displayImageCurrentY, displayImageScale);
            }, false);

            function updateDisplayImage(x, y, scale) {
              const transform = 'translateX(' + x + 'px) translateY(' + y + 'px) translateZ(0px) scale(' + scale + ',' + scale + ')';
              displayImage.style.transform = transform;
              displayImage.style.WebkitTransform = transform;
              displayImage.style.msTransform = transform;
            }

            function updateRange() {
              rangeX = Math.max(0, Math.round(displayDefaultWidth * displayImageCurrentScale) - containerWidth);
              rangeY = Math.max(0, Math.round(displayDefaultHeight * displayImageCurrentScale) - containerHeight);

              rangeMaxX = Math.round(rangeX / 2);
              rangeMinX = 0 - rangeMaxX;

              rangeMaxY = Math.round(rangeY / 2);
              rangeMinY = 0 - rangeMaxY;
            }


            const hammertime = new Hammer(imageContainer);

            hammertime.get('pinch').set({ enable: true });
            hammertime.get('pan').set({ direction: Hammer.DIRECTION_ALL });

            hammertime.on('pan', function(ev)  {
              displayImageCurrentX = clamp(displayImageX + ev.deltaX, rangeMinX, rangeMaxX);
              displayImageCurrentY = clamp(displayImageY + ev.deltaY, rangeMinY, rangeMaxY);
                updateDisplayImage(displayImageCurrentX, displayImageCurrentY, displayImageScale);
            });

            hammertime.on('pinch pinchmove', function(ev) {
              displayImageCurrentScale = clampScale(ev.scale * displayImageScale);
              updateRange();
              displayImageCurrentX = clamp(displayImageX + ev.deltaX, rangeMinX, rangeMaxX);
              displayImageCurrentY = clamp(displayImageY + ev.deltaY, rangeMinY, rangeMaxY);
              updateDisplayImage(displayImageCurrentX, displayImageCurrentY, displayImageCurrentScale);
            });

            hammertime.on('panend pancancel pinchend pinchcancel', function() {
              displayImageScale = displayImageCurrentScale;
              displayImageX = displayImageCurrentX;
              displayImageY = displayImageCurrentY;
            });
        }
}
