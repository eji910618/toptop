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
