

$(document).ready(function() {
	$('.effect-scroll').each(function(i,o){
		Effect.scroll(i);
	});
	Effect.click();
	Effect.hover();
});

var Effect = {
	scroll : function(i){
		var v = window.outerHeight / 2;
		$(window).on('scroll', function(){
			var p = $(this).scrollTop() + v;
			var $e = $('.effect-scroll').eq(i);
			if(p > $e.offset().top && p < $e.offset().top + $e.innerHeight()){
				$e.find('.effect').addClass('active');
			}
			if(p < $e.offset().top - v || p > $e.offset().top + $e.innerHeight() + v){
				$e.find('.effect').removeClass('active');
			}
		});
	},
	click : function(){
		$('.effect-click').on('click', function(){
			$(this).addClass('active');
		});
	},
	hover : function(){
		$('.effect-hover .effect').off('mouseover').on('mouseover', function(){
			$(this).addClass('active');
		}).off('mouseleave').on('mouseleave', function(){
			$(this).removeClass('active');
		});
	}
}