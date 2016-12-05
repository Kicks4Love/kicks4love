var currentIndex = 0;
var Slide = {};

$(document).ready(function() {	
	// set HOME menu selected
	$('#navbar ul li').eq(0).addClass('active');

	/*--轮播图-slidebar--*/
	Slide.slideLength = $('.slide-bar-container ul li').length;
	Slide.slideUnorderList = $('.slide-bar-container ul li');
	Slide.slideOrderList = $('.slide-bar-container ol li');

	Slide.slideOrderList.eq(0).addClass("active");
	
	for(var i = 1; i < Slide.slideLength; i++) Slide.slideUnorderList.eq(i).css('left','100%');
	for(var i = 0; i < Slide.slideLength; i++) {
		Slide.slideUnorderList.eq(i).css('z-index',i);
		$('.slide-bar-container ul p').eq(i).css('z-index',i+$('.slide-bar-container .slide-filter').css('z-index'));
	}
	
	var timer = setInterval(slide,2000);
	
	$('.slide-bar-container ul').hover(function(){
		$('.slide-bar-container .slide-filter').fadeIn();
		$('.slide-bar-container ul p').eq(currentIndex).fadeIn();
		clearInterval(timer);
	},function(){
		$('.slide-bar-container .slide-filter').fadeOut();
		$('.slide-bar-container ul p').eq(currentIndex).fadeOut();
		timer=setInterval(slide,2000);
	});
	
	$('.slide-bar-container ol li').each(function() {
		$(this).hover(function(){
			clearInterval(timer);
			if(currentIndex<$(this).index()){
				$('.slide-bar-container ol li').eq(currentIndex).removeClass("active");
				currentIndex=$(this).index();
				$('.slide-bar-container ol li').eq(currentIndex).addClass("active");
				$('.slide-bar-container ul li').eq(currentIndex).animate({
					left:'0%'
				})
			}else if(currentIndex>$(this).index()){
				$('.slide-bar-container ol li').eq(currentIndex).removeClass("active");
				currentIndex=$(this).index();
				$('.slide-bar-container ol li').eq(currentIndex).addClass("active");
				$('.slide-bar-container ul li').eq(currentIndex).css('left',0);
				for(var j=currentIndex+1; j<Slide.slideLength; j++){
					$('.slide-bar-container ul li').eq(j).animate({
						left:'100%'
					})
				}
			}		
		}, function(){
			timer = setInterval(slide,2000);
		})
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
	});

	initLoadPostHandler();
});

function initLoadPostHandler() {
	/*--点击加载-lazyload--*/
	$('.to-view-more').click(function() {
		var postIndex = $('#post_index');
		var target = $(this);
		target.find('span').text('Loading...');

		$.ajax({
			type: 'GET',
            url: '/main/get_posts?index=' + postIndex.val() +'&source_page=index',
            dataType: "json",
            success: function(data) { 
            	var parent = target.parent('.main');
            	$('.kicks-box.last').removeClass('last');
            	for (var i = 0; i < data.posts.length; i++) {
            		parent.append(
            			'<div class="kicks-box wait_load clearfix' + (i === data.posts.length - 1 ? ' last' : '') + '">' +
            			'<div class="kicks-pic">' +
                		'<img src="assets/post/' + data.posts[i].image + '" style="width:100%">' + 
                		'<div class="kicks-filter">' + 
                		'</div><a href="#"><p>Placeholder</p></a><div class="kicks-title">' + 
                		'</div></div>' +
            			'<div class="kicks-intro">' + 
                		'<h2>' + data.posts[i].title + '</h2>' +
                		'<div class="kicks-intro-content">' + 
                    	'<span>' + data.posts[i].content + '</span>' +
                		'</div></div></div>'
            		);
            	}
            	if (!data.no_more) {
	            	parent.append('<div class="to-view-more"><span>Click To View More</span></div>');
	            	postIndex.val(parseInt(postIndex.val()) + 3);
	            }
            	target.fadeOut();
            	$('.wait_load').fadeIn(1000);
            	initLoadPostHandler();
            }
		});
	});
}

function slide() {
	$('.slide-bar-container ol li').eq(currentIndex).removeClass("active");
	currentIndex++;
		
	$('.slide-bar-container ol li').eq(currentIndex).addClass("active");
	$('.slide-bar-container ul li').eq(currentIndex).animate({left:'0%'});
	if(currentIndex == Slide.slideLength) {
		currentIndex=0;
		$('.slide-bar-container ol li').eq(currentIndex).addClass("active");
		for(var j=currentIndex+1; j<Slide.slideLength; j++)
			$('.slide-bar-container ul li').eq(j).animate({left:'100%'});
	}
}