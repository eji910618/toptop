if($('#dispBannerNo').val() == 2067){
(function(){

	$.fn.dalChart = function(total, joins, opts){

		var defaults = {
			dur: 550,
			ease: "easeIn"
		},
		options = $.extend(defaults, opts);

		return this.each(function(){

			var $el = $(this),
			$prgrs = $el.find('.prgrs'),
			$prgrsRight = $el.find('.prgrs-right'),
			calcPercentage = Math.floor( (joins / total) * 100 ),
			calcMinPercent = Math.floor( 100 - calcPercentage );

			$prgrs.animate({
				width: Math.floor( calcPercentage ) + '%'
			}, options.dur, options.ease );

			$prgrsRight.animate({
				width: Math.floor( calcMinPercent ) + '%'
			}, options.dur, options.ease );

			$prgrs.html('<i class="count">'+calcPercentage+'</i><em>%</em>');
			$prgrsRight.html('<i class="count">'+calcMinPercent+'</i><em>%</em>');

			$prgrs.find('i').eq(0).prop('Counter', 0).animate({
				Counter: parseInt($prgrs.find('i').eq(0).text())
			}, {
				duration: options.dur * 2,
				easing: 'swing',
				step: function(now){
					$prgrs.find('i').eq(0).text(Math.ceil(now));
				}
			});

			$prgrsRight.find('i').eq(0).prop('Counter', 0).animate({
				Counter: parseInt($prgrsRight.find('i').eq(0).text())
			}, {
				duration: options.dur * 2,
				easing: 'swing',
				step: function(now){
					$prgrsRight.find('i').eq(0).text(Math.ceil(now));
				}
			});

			$el.find('.count, em').css({
				'opacity': 1
			});

			// for(var i=0; i<$el.find('i.count').length; i++) {

			// 	$el.find('i.count').eq(i).prop('Counter', 0).animate({
			// 		Counter: parseInt($(this).text())
			// 	}, {
			// 		duration: 4000,
			// 		easing: 'swing',
			// 		step: function(now){
			// 			$(this).text(Math.ceil(now));
			// 		}
			// 	});

			// }



		});
		return this;
	};

})();
}else{
	(function(){
		$.fn.dalChart = function(total, joins, opts){
			var defaults = {
				dur: 550,
				ease: "easeIn"
			},
			options = $.extend(defaults, opts);
			return this.each(function(){
				var $el = $(this),
				$prgrs = $el.find('.prgrs'),
				calcPercentage = (joins / total) * 100;

				$prgrs.stop(true, true).animate({
					width: calcPercentage + '%'
				}, options.dur, options.ease );
			});
			return this;
		};
	})();
}