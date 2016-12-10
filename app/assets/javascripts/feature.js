$(document).ready(function(){
	// set FEATURES menu selected
	$('#navbar ul li').eq(1).addClass('active');
	
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
		var nextPage = $('#next_page');
		var target = $(this);
		target.find('span').text('Loading...');

		$.ajax({
			type: 'GET',
            url: '/main/get_posts?next_page=' + nextPage.val() + '&source_page=features',
            dataType: "json",
            success: function(data) { 
            	var parent = target.parent('.main');
            	for (var i = 0; i < data.posts.length; i++) {
            		parent.append(
            			'<div class="kicks-box wait_load clearfix">' +
            			'<dl><dt>' +
            			'<a href="#">' + 
                		'<img src="assets/feature_post/' + data.posts[i].image + '" style="width:100%">' + 
                		'<div class="filter">' + 
                		'<p>PlaceHolder</p>' + 
                		'</div></a></dt><dd><a href="#">PlaceHolder</a></dd></dl>' +
            			'<div class="kicks-intro">' + 
                		'<h2>' + data.posts[i].title + '</h2>' +
                		'<div class="kicks-intro-content">' + 
                    	'<span>' + data.posts[i].content + '</span>' +
                		'</div></div></div>'
            		);
            	}
            	if (!data.no_more) {
	            	parent.append('<div class="to-view-more"><span>Click To View More</span></div>');
	            	nextPage.val(parseInt(nextPage.val()) + 1);
	            }
            	target.fadeOut();
            	$('.wait_load').fadeIn(1000);
            	initLoadPostHandler();
            }
		});
	});
}