// JavaScript Document

$(function(){
	
	$('.navbar-toggle').click(function(){
		$('.navbar-collapse ul').addClass('down');
		if($('.navbar-collapse ul').hasClass('in')){
			$('.collapse ul').slideUp();
			$('.header').animate({
				'margin-top': '80px',
			})
			$('.navbar-collapse ul').removeClass('in');
			$('.navbar-collapse ul').removeClass('down');
		}
		
		if($('.navbar-collapse ul').hasClass('down')){
			$('.collapse ul').css('background','#F8F8F8').css('width','100%').css('position','absolute').css('top','70px').css('left','15px').slideDown();
			$('.header').animate({
				'margin-top': '160px',
			})
			$('.collapse ul li').eq(0).css('display','none');
			$('.navbar-collapse ul').addClass('in');
		}
		
	});
	
	$('.main dl').hover(function(){
		$(this).find('.filter').fadeIn();
	},function(){
		$(this).find('.filter').fadeOut();
	});
	
	/*--点击加载-lazyload--*/
	var wait_load=$('.wait_load');
	$('.to-view-more').click(function(){
		$(this).fadeOut();
		wait_load.fadeIn(1000);
	});
	
	/*--新鞋介绍-main--*/
	$('.kicks-pic').hover(function(){
		var filter=$(this).find('.kicks-filter');
		var title=$(this).find('p');
		filter.animate({
			opacity:0.8,
			width:'100%'
		},1000);
		title.fadeIn(1000);
	},function(){
		var filter=$(this).find('.kicks-filter');
		var title=$(this).find('p');
		filter.animate({
			opacity:0,
			width:'0'
		},1000);
		title.fadeOut(1000);
	})
	
})