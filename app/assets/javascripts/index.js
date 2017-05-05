var autoSlider = null;

$(document).on('turbolinks:load', function() {
	if (getSourcePage() !== 'index') return;

	// set HOME menu selected
	$('#navbar ul li').eq(0).addClass('active');
	deinitilize();

	initImageSlider();
	console.log('index');

	initLoadPostHandler();
    setTimeout(function() { 
        $('.header > img').slideUp('slow'); 
        $('.logo-pendant').fadeIn('slow');
    }, 2000);
    initLanguageFormHandler();
});

function deinitilize() {
	console.log(autoSlider);
	$('#next').off('click');
	$('#previous').off('click');
	$('#slider-wrap').off('hover');
	$('.to-view-more').off('click');
	$('#pagination-wrap ul').empty();
	if (autoSlider != null) clearInterval(autoSlider);
	autoSlider = null;
}

function initImageSlider() {
	var pos = 0;
	var totalSlides = $('#slider-wrap ul li').length;	
	
	$(window).resize(function() {
		var width = $('#slider-wrap').width();
		$('#slider-wrap ul#slider li').width(width);
		$('#slider-wrap ul#slider').width(width*totalSlides);
	});
	$(window).trigger('resize');
	 	
	$('#next').click(function(){slideRight();});
	$('#previous').click(function(){slideLeft();});
	
	autoSlider = setInterval(slideRight, 3000);
	
	$.each($('#slider-wrap ul li'), function() { 
	   var color = $(this).attr("data-color");
	   $(this).css("background-color", color);
	   
	   var li = document.createElement('li');
	   $('#pagination-wrap ul').append(li);	   
	});
	pagination();

	$('#slider-wrap').hover(
	  	function(){ $(this).addClass('active'); console.log('hover'); clearInterval(autoSlider); }, 
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
		$('#pagination-wrap ul li').removeClass('active');
		$('#pagination-wrap ul li:eq('+pos+')').addClass('active');
	}
}

function initLoadPostHandler() {
	/*--点击加载-lazyload--*/
	$('.to-view-more').click(function() {
		console.log('click');
		var chinese = isChinese();
		var nextPage = $('#next_page');
		var target = $(this);
		target.find('span').text(chinese ? '加载中...' : 'Loading...');

		$.ajax({
			type: 'GET',
            url: '/main/get_posts?next_page=' + nextPage.val() +'&source_page=index',
            dataType: "json",
            success: function(data) { 
            	var parent = target.parent('.main');
            	$('.kicks-box.last').removeClass('last');
            	for (var i = 0; i < data.posts.length; i++) {
            		parent.append(
            			'<div class="kicks-box wait_load clearfix' + (i === data.posts.length - 1 ? ' last' : '') + '">' +
            			'<a href="' + data.posts[i].post_link + '">' +
                		'<img src="' + data.posts[i].image_url + '" class="col-xs-12 col-sm-4 kicks-pic"></a>' + 
            			'<div class="col-xs-12 col-sm-8 kicks-intro">' + 
                		'<h2>' + data.posts[i].post.title + '</h2>' +
                		'<hr class="title-divider">' +
                		'<div class="kicks-intro-content">' + 
                    	'<span>' + data.posts[i].post.content.slice(0, 300) + '...</span>' +
                    	'<a href="' + data.posts[i].post_link + '">(' + (chinese ? '更多' : 'more') + ')</a>' +
                    	'<span class="post-date">' + data.posts[i].post.created_at.slice(0, 10) + '</span>' +
                		'</div></div></div>'
            		);
            	}
            	if (!data.no_more) {
	            	parent.append('<div class="to-view-more"><span>' + (chinese ? '点击加载更多' : 'Click to view more') + '</span></div>');
	            	nextPage.val(parseInt(nextPage.val()) + 1);
	            }
            	target.fadeOut();
            	$('.wait_load').fadeIn(1000);
            	initLoadPostHandler();
            }
		});
	});
}