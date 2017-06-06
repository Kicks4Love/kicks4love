$(document).ready(function() {
      if (getSourcePage() !== 'feature') return;
      console.log("feature");

	// set FEATURES menu selected
	$('#navbar ul li').eq(1).addClass('active');

	initLoadPostHandler();
	initApplication(true, true);
});

function initLoadPostHandler() {
	/*--点击加载-lazyload--*/
	$('.to-view-more.current').one('click', function() {
            var chinese = isChinese();
		var nextPage = $('#next_page');
		var target = $(this);
            target.removeClass('current');
		target.find('span').text(chinese ? '加载中...' : 'Loading...');

		$.ajax({
			type: 'GET',
                  url: '/main/get_posts?next_page=' + nextPage.val() + '&source_page=features',
                  dataType: 'json',
                        success: function(data) { 
                  	var parent = target.parent('.main');
                  	for (var i = 0; i < data.posts.length; i++) {
                              var right;
                              if (nextPage.val()%2 === 1)
                                    right = i%2 === 1;
                              else
                                    right = i%2 === 0;
                  		parent.append(
                              '<div class="kicks-post' + (right ? ' alt' : '') + '">' +
                              '<a href="/features/' + data.posts[i].post.id + '">' +
                              '<div class="photo ' + (right ? 'photo-right' : 'photo-left') + '" style="background-image:url(' + data.posts[i].image_url + ');background-size:cover;background-position:center"></div>' +
                              '</a><div class="kicks-post-content">' +
                              '<a href="/features/' + data.posts[i].post.id + '"><h1>' + data.posts[i].post.title + '</h1></a>' + 
                              '<h2>' + data.posts[i].post.created_at.slice(0, 10) + '</h2>' + 
                              // hacky way to remove any html tags in the content
                              '<p>' + $('<p>' + data.posts[i].post.content[0] + '</p>').text().trim().slice(0, 120) + '...</p>' + 
                              '<a href="/features/' + data.posts[i].post.id + '" class="kicks-post-more">' + (chinese ? '更多' : 'more') + '</a>' +
                              '</div></div>'
                  		);
            	     }
            	     if (!data.no_more) {
	            	    parent.append('<div class="to-view-more current"><span>' + (chinese ? '点击加载更多' : 'Click To View More') + ' <i class="fa fa-arrow-circle-down" aria-hidden="true"></i></span></div>');
	            	    nextPage.val(parseInt(nextPage.val()) + 1);
	                 }
            	     target.fadeOut();
            	     $('.wait_load').fadeIn(1000);
            	     initLoadPostHandler();
                  }
		});
	});
}