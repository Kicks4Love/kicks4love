$(document).ready(function() {
	if (getSourcePage() !== 'index') return;
	console.log('index');

	// set HOME menu selected
	$('#navbar ul li').eq(0).addClass('active');

	initImageSlider();
	initLoadPostHandler();
    initApplication(true, true);
    $(window).trigger('resize');
});

function initImageSlider() {
	var pos = 0;
	var totalSlides = $('#slider-wrap ul#slider li').length;	
	
	$(window).resize(function() {
		var width = $('#slider-wrap').width();
		$('#slider-wrap ul#slider li').width(width);
		$('#slider-wrap ul#slider').width(width*totalSlides);
	});
	$(window).trigger('resize');
	 	
	$('#next').click(function(){slideRight();});
	$('#previous').click(function(){slideLeft();});
		
	$('#pagination-wrap ul').empty();
	$.each($('#slider-wrap ul li'), function() { 	   
	   var li = document.createElement('li');
	   $('#pagination-wrap ul').append(li);	   
	});
	pagination();

	if (autoSlider == null) autoSlider = setInterval(slideRight, 3000);
	$('#slider-wrap').hover(
	  	function(){ $(this).addClass('active'); clearInterval(autoSlider); }, 
	  	function(){ $(this).removeClass('active'); autoSlider = setInterval(slideRight, 3000); }
	);

	function slideLeft(){
		pos--;
		if(pos==-1){ pos = totalSlides-1; }
		$('#slider-wrap ul#slider').css('left', -($('#slider-wrap').width()*pos)); 	
		pagination();
	}

	function slideRight(){
		pos++;
		if(pos==totalSlides){ pos = 0; }
		$('#slider-wrap ul#slider').css('left', -($('#slider-wrap').width()*pos)); 
		pagination();
	}

	function pagination(){
		$(window).trigger('resize');
		$('#pagination-wrap ul li').removeClass('active');
		$('#pagination-wrap ul li:eq('+pos+')').addClass('active');
	}
}

function initLoadPostHandler() {
	var sneakerImgPath = $('.main .kicks-box .kicks-intro .kicks-intro-content .rating img').attr('src');
	$('.to-view-more.current').one('click' ,function() {
		var target = $(this);
		var chinese = isChinese();
		var nextPage = $('#next_page');
		target.removeClass('current');
		target.find('span').text(chinese ? '加载中...' : 'Loading...');

		$.ajax({
			type: 'GET',
            url: '/main/get_posts?next_page=' + nextPage.val() +'&source_page=index',
            dataType: "json",
            success: function(data) { 
            	var parent = target.parent('.main');
            	$('.kicks-box.last').removeClass('last');
            	for (var i = 0; i < data.posts.length; i++) {
            		var tag = '';
            		switch (data.posts[i].post_type) {
            			case 'features':
            				tag = chinese ? '专题' : 'Features';
            				break;
            			case 'trend':
            				tag = chinese ? '潮流趋势' : 'Trend';
            				break;
            			case 'oncourt':
            				tag = chinese ? '球场时装' : 'On Court';
            				break;
            			case 'streetsnap':
            				tag = chinese ? '街拍' : 'Street Snap';
            				break;
            			case 'rumors':
            				tag = chinese ? '流言蜚语' : 'Rumors';
            				break;
            		}
            		parent.append(
            			'<div class="kicks-box wait_load clearfix' + (i === data.posts.length - 1 ? ' last' : '') + '">' +
            			'<a href="/' + data.posts[i].post_type + '/' + data.posts[i].post.id + '">' +
                		'<img src="' + data.posts[i].image_url + '" class="col-xs-12 col-sm-4 kicks-pic"></a>' + 
            			'<div class="col-xs-12 col-sm-8 kicks-intro">' + 
            			'<a href="/' + data.posts[i].post_type + '/' + data.posts[i].post.id + '">' +
                		'<div class="feed-title"><h3>' + data.posts[i].post.title + '</h3></div></a>' +
                		'<hr class="title-divider">' +
                		'<div class="kicks-intro-content">' + 
                		// hacky way to remove any html tags in the content
                    	'<p>' + $('<p>' + data.posts[i].post.content[0] + '</p>').text().trim().slice(0, 120) + '... ' +
                    	'<a href="/' + data.posts[i].post_type + '/' + data.posts[i].post.id + '">(' + (chinese ? '更多' : 'more') + ')</a>' +
                    	'<span class="post-date">' + data.posts[i].post.created_at.slice(0, 10) + '</span></p>' +
                    	'<br/><i class="fa fa-tags" aria-hidden="true"></i>' +
                    	'<span class="post-tag">' + tag + '</span>' +
                    	'<div class="rating">' + data.posts[i].score + '/5.0 <img height="15" src="' + sneakerImgPath + '"/></div>' +
                    	'</div></div></div>'
            		);
            	}
            	if (!data.no_more) {
	            	parent.append('<div class="to-view-more current"><span>' + (chinese ? '点击加载更多' : 'Click to view more') + ' <i class="fa fa-arrow-circle-down" aria-hidden="true"></i></span></div>');
	            	nextPage.val(parseInt(nextPage.val()) + 1);
	            }
            	target.fadeOut();
            	$('.wait_load').fadeIn(1000);
            	initLoadPostHandler();
            }
		});
	});
}