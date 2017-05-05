$(document).ready(function() {
    if (getSourcePage() !== 'trend') return;

    // set FEATURES menu selected
	$('#navbar .dropdown ul li').eq(0).addClass('active');
	console.log("trend");

	initLoadPostHandler();
	setTimeout(function() { $('.logo-pendant').fadeIn('slow'); }, 1000);
	initLanguageFormHandler();
});

function initLoadPostHandler() {
	/*--点击加载-lazyload--*/
	$('.to-view-more').click(function() {
        var chinese = isChinese();
		var nextPage = $('#next_page');
		var target = $(this);
		target.find('span').text(chinese ? '加载中...' : 'Loading...');

		$.ajax({
			type: 'GET',
            url: '/main/get_posts?next_page=' + nextPage.val() + '&source_page=trend',
            dataType: "json",
            success: function(data) { 
            	var parent = target.parent('.main');
            	for (var i = 0; i < data.posts.length; i++) {
            		parent.append(
            			'<div class="kicks-box wait_load clearfix' + (i+1 === data.posts.length ? ' last' : '') + '">' +
            			'<dl class="col-xs-12 col-sm-4"><dt>' +
                		'<img src="' + data.posts[i].image_url + '" class="kicks-pic">' + 
                		'</dt><dd><a href="/trend/' + data.posts[i].post.id + '">' + data.posts[i].post.title + '</a></dd></dl>' +
            			'<div class="col-xs-12 col-sm-8 kicks-intro">' + 
                		'<h2>' + data.posts[i].post.title + '</h2>' +
                		'<div class="kicks-intro-content">' + 
                    	'<span>' + data.posts[i].post.content + '</span>' +
                		'</div></div></div>'
            		);
            	}
            	if (!data.no_more) {
	            	parent.append('<div class="to-view-more"><span>' + (chinese ? '点击加载更多' : 'Click To View More') + '</span></div>');
	            	nextPage.val(parseInt(nextPage.val()) + 1);
	            }
            	target.fadeOut();
            	$('.wait_load').fadeIn(1000);
            	initLoadPostHandler();
            }
		});
	});
}