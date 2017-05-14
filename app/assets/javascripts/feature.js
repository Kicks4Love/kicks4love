$(document).ready(function() {
      if (getSourcePage() !== 'feature') return;

	// set FEATURES menu selected
	$('#navbar ul li').eq(1).addClass('active');
	console.log("feature");

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
            url: '/main/get_posts?next_page=' + nextPage.val() + '&source_page=features',
            dataType: "json",
            success: function(data) { 
            	var parent = target.parent('.main');
            	for (var i = 0; i < data.posts.length; i++) {
                        var right = i%2 == 0;
            		parent.append(
                        '<div class="kicks-post' + (right ? ' alt' : '') + '">' +
                        '<div class="photo ' + (right ? 'photo-right' : 'photo-left') + '" style="background:url(' + data.posts[i].image_url + ');background-size:cover;background-position:center"></div>' +
                        '<div class="kicks-post-content">' +
                        '<a href="/features/' + data.posts[i].post.id + '"><h1>' + data.posts[i].post.title + '</h1></a>' + 
                        '<h2>' + data.posts[i].post.created_at.slice(0, 10) + '</h2>' + 
                        '<p>' + data.posts[i].post.content.slice(0, 200) + '...</p>' + 
                        '<a href="/features/' + data.posts[i].post.id + '" class="kicks-post-more">' + (chinese ? '更多' : 'more') + '</a>' +
                        '</div></div>'
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