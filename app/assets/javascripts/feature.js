$(document).ready(function(){
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
		var postIndex = $('#feature_post_index');
		var target = $(this);
		target.find('span').text('Loading...');

		$.ajax({
			type: 'GET',
            url: '/main/get_posts?index=' + postIndex.val() + '&source_page=features',
            dataType: "json",
            success: function(data) { 
            	var parent = target.parent('.main');
            	for (post in data.posts) {
            		parent.append(
            			'<div class="kicks-box wait_load clearfix">' +
            			'<dl><dt>' +
            			'<a href="#">' + 
                		'<img src="assets/feature_post/' + data.posts[post].image + '" style="width:100%">' + 
                		'<div class="filter">' + 
                		'<p>PlaceHolder</p>' + 
                		'</div></a></dt><dd><a href="#">PlaceHolder</a></dd></dl>' +
            			'<div class="kicks-intro">' + 
                		'<h2>' + data.posts[post].title + '</h2>' +
                		'<div class="kicks-intro-content">' + 
                    	'<span>' + data.posts[post].content + '</span>' +
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