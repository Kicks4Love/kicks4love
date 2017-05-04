$(document).ready(function() {
	if (getSourcePage() !== 'index') return;

	// set HOME menu selected
	$('#navbar ul li').eq(0).addClass('active');

	initImageSlider();
	console.log('index');
	
	/*--新鞋介绍-main--*/
	$('.new-box').hover(function(){
		var filter = $(this).find('.kicks-filter');
		var title = $(this).find('p');
		filter.animate({
			opacity:0.8,
			width:'100%'
		},1000);
		title.fadeIn(1000);
	},function(){
		var filter = $(this).find('.kicks-filter');
		var title = $(this).find('p');
		filter.animate({
			opacity:0,
			width:'0'
		},1000);
		title.fadeOut(1000);
	});

	initLoadPostHandler();
    setTimeout(function() { 
        $('.header > img').slideUp('slow'); 
        $('.logo-pendant').fadeIn('slow');
    }, 2000);
    initLanguageFormHandler();
});

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
	
	var autoSlider = setInterval(slideRight, 3000);
	
	$.each($('#slider-wrap ul li'), function() { 
	   var color = $(this).attr("data-color");
	   $(this).css("background-color", color);
	   
	   var li = document.createElement('li');
	   $('#pagination-wrap ul').append(li);	   
	});
	pagination();

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
		$('#pagination-wrap ul li').removeClass('active');
		$('#pagination-wrap ul li:eq('+pos+')').addClass('active');
	}
}

function initLoadPostHandler() {
	/*--点击加载-lazyload--*/
	$('.to-view-more').click(function() {
		var chinese = $('#language').val() == 'cn';
		var nextPage = $('#next_page');
		var target = $(this);
		target.find('span').text('Loading...');

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
                    	'<span>' + data.posts[i].post.content + '...</span>' +
                    	'<a href="' + data.posts[i].post_link + '">(' + (chinese ? '更多' : 'more') + ')</a>' +
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