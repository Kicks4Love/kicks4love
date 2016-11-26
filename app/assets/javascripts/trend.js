// JavaScript Document

$(function(){
	$('.navbar-toggle').click(function(){
		$('.navbar-collapse ul').addClass('down');
		if($('.navbar-collapse ul').hasClass('in')){
			$('.collapse ul').slideUp();
			$('.header').animate({
				'margin-top': '0px',
			})
			$('.navbar-collapse ul').removeClass('in');
			$('.navbar-collapse ul').removeClass('down');
		}
		
		if($('.navbar-collapse ul').hasClass('down')){
			$('.collapse ul').css('background','#F8F8F8').css('width','100%').css('position','absolute').css('top','70px').css('left','15px').slideDown();
			$('.header').animate({
				'margin-top': '40px',
			})
			$('.collapse ul li').eq(0).css('display','none');
			$('.navbar-collapse ul').addClass('in');
		}
		
	});
	
	if($('.photo').eq(0).offsetHeight > $('.photo').eq(1).offsetHeight){
		$('.photo').eq(0).css('border-left','2px solid #000000');
	} else {
		$('.photo').eq(1).css('border-right','2px solid #000000');
	}
	
	//延迟加载
	var photo_1=$('.photo ul').eq(0);
	var photo_2=$('.photo ul').eq(1);
	var wait_load_1=photo_1.children('.wait_load');
	var wait_load_2=photo_2.children('.wait_load');
	wait_load_1.css('opacity','0');
	wait_load_2.css('opacity','0');
	$(window).bind('scroll',function(){
		setTimeout(function(){
			for(var i=0; i<wait_load_1.length; i++){
				var _this=wait_load_1.eq(i);
				if($(this).height()+$(this).scrollTop()>=_this.offset().top && _this.css('opacity')==0){
					$(_this).animate({
						opacity:100
					},2000);
				}
			}
		},1000);
		setTimeout(function(){
			for(var i=0; i<wait_load_2.length; i++){
				var _this=wait_load_2.eq(i);
				if($(this).height()+$(this).scrollTop()>=_this.offset().top && _this.css('opacity')==0){
					$(_this).animate({
						opacity:100
					},2000);
				}
			}
		},1000);
	})
	
	if($(window).width()<=768){
		$('br').remove();
		wait_load_1.eq(0).css('opacity',100);
		wait_load_2.eq(0).css('opacity',100);
		wait_load_1.eq(0).removeClass('wait_load');
		wait_load_2.eq(0).removeClass('wait_load');
	}
})