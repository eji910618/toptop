var sdk = {};

sdk.fingerPush = {
    setIdentity : function(memberNo) {
        sendToFingerPush(memberNo);
    }
}

sdk.branch = {
	init : function(key){
		if(appCd != 'A' && appCd != 'I'){
			// load Branch
			(function(b,r,a,n,c,h,_,s,d,k){if(!b[n]||!b[n]._q){for(;s<_.length;)c(h,_[s++]);d=r.createElement(a);d.async=1;d.src="https://cdn.branch.io/branch-latest.min.js";k=r.getElementsByTagName(a)[0];k.parentNode.insertBefore(d,k);b[n]=h}})(window,document,"script","branch",function(b,r){b[r]=function(){b._q.push([r,arguments])}},{_q:[],_v:1},"addListener applyCode autoAppIndex banner closeBanner closeJourney creditHistory credits data deepview deepviewCta first getCode init link logout redeem referrals removeListener sendSMS setBranchViewData setIdentity track validateCode trackCommerceEvent logEvent disableTracking".split(" "), 0);
			// init Branch
			branch.init(key, function(err, data){});
			branch.data(function(err, data) {});
		}
	},
	logEvent : function(event_name, event_and_custom_data, content_items) {

		console.log("--- Branch LogEvent ---");

		if (appCd != 'A' && appCd != 'I') {
			branch.logEvent(event_name, event_and_custom_data, content_items, function(err) { console.log(err); });
		} else {
			var data = createJsonStringObject(event_name, event_and_custom_data, content_items);
			sendToBranchEvent(data);
		}
	}
}

sdk.braze = {
	customLogEvent : function(event_name, content_items) {

		console.log("--- Braze CustomLogEvent ---");

		var data = createJsonStringObject(event_name, content_items);
		sendToBrazeCustomEvent(data);
	},

	purchaseLogEvent : function(event_name, content_items) {

		console.log("--- Braze PurchaseLogEvent ---");

		var data = createJsonStringObject(event_name, content_items);
		sendToBrazePurchaseEvent(data)
	},

	selectPushData : function() {

		console.log("--- selectPushData ---")

		selectPushDataFromBraze()

	},

	sendUid : function() {

	}

	// EVENT TEST DATA
	/*test : function() {
		var str1 = {
			"currency" : "KRW"
		};
		var str2 = [ {
			"$sku" : "test_test01",
			"$product_name" : "테스트옷1",
			"$price" : 100,
			"$quantity" : 1
		}, {
			"$sku" : "test_test02",
			"$product_name" : "테스트옷2",
			"$price" : 200,
			"$quantity" : 2
		} ];

		var data = createJsonStringObject("PURCHASE", str1, str2);
		sendToBrazePurchaseEvent(data);

	},*/
}

function createJsonStringObject() {

	if (arguments.length == 2) {

		var jsonObject = new Object();
		jsonObject.name = arguments[0]; // event_name
		jsonObject.content = arguments[1]; // content_items
		var data = JSON.stringify(jsonObject);

		return data;

	} else if (arguments.length == 3) {

		var jsonObject = new Object();
		jsonObject.name = arguments[0]; // event_name
		jsonObject.custom = arguments[1]; // event_and_custom_data
		jsonObject.content = arguments[2]; // content_items
		var data = JSON.stringify(jsonObject);

		return data;
	}

};

function sendToFingerPush(data) {

    try {
        if (isAndroidApp) {
            window.android.setIdentity(data);
        } else if (isIosApp) {
            webkit.messageHandlers.setIdentity.postMessage(data);
        }
    } catch (e) {
        console.log("*** FingerPush setIdentity Error ***");
    }
}

function sendToBranchEvent(data) {

	try {
		if (isAndroidApp) {
			window.android.branchEventForAndroid(data);
		} else if (isIosApp) {
			webkit.messageHandlers.branch.postMessage(data);
		}
	} catch (e) {
		console.log("*** Branch Event Send Error ***");
	}

};

function sendToBrazeCustomEvent(data) {

	try {
		if (isAndroidApp) {
			window.android.brazeCustomEvent(data);
		} else if (isIosApp) {
			webkit.messageHandlers.brazeCustomEvent.postMessage(data);
		}
	} catch (e) {
		console.log("*** Braze Cunstom Event Send Error ***");
	}

};

function sendToBrazePurchaseEvent(data) {

	try {
		if (isAndroidApp) {
			window.android.brazePurchaseEvent(data);
		} else if (isIosApp) {
			webkit.messageHandlers.brazePurchaseEvent.postMessage(data);
		}
	} catch (e) {
		console.log("*** Braze Purchase Event Send Error ***");
	}

};

function selectPushDataFromBraze() {

	try {
		if (isAndroidApp) {
			window.android.getPushDataFromBraze();
		} else if (isIosApp) {
			webkit.messageHandlers.getPushDataFromBraze.postMessage("");
		}
	} catch (e) {
		console.log("*** Select Braze Push Data Error ***");
	}

};
