$(document).ready(function() {
    if (getSourcePage() !== 'trend') return;

    // set TREND menu selected
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
                console.log(data);
            	var parent = $('#kicks-posts');
                console.log(parent);
            	for (var i = 0; i < data.posts.length; i++) {
            		parent.append(
                        '<a href="/trend/' + data.posts[i].post.id + '" class="kicks-post col-xs-12 col-sm-6 col-lg-4 wait_load" ' +
                        'style="background-image:url(' + data.posts[i].image_url + ');">' +
                        '<h3>' + data.posts[i].post.title + '</h3>' +
                        '<span class="lead kicks-date">' + data.posts[i].post.created_at.slice(0, 10) + '</span></a>'
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