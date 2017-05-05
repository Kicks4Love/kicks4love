$(document).ready(function() {	
<<<<<<< 22119e9b203bf88a36237b8e2335de321165fdb0
	if (getSourcePage() !== 'oncourt') return;

	// set HOME menu selected
	$('#navbar .dropdown ul li').eq(1).addClass('active');
	console.log("on court");

=======
	// set ONCOURT menu selected
	$('#navbar .dropdown ul li').eq(1).addClass('active');
>>>>>>> adding menu selected active and fix ajax call data post missing
	initLoadPostHandler();
	setTimeout(function() { $('.logo-pendant').fadeIn('slow'); }, 1000);
	initLanguageFormHandler();
});

/*--点击加载-lazyload--*/
function initLoadPostHandler() {
	$('.to-view-more').click(function(){
		var chinese = isChinese();
		var nextPage = $('#next_page');
		var target = $(this);
		target.find('span').text(chinese ? '加载中...' : 'Loading...');

		$.ajax({
			type: 'GET',
			url: '/main/get_posts?next_page=' + nextPage.val() + '&source_page=on_court',
			dataType: "json",
			success: function(data) {
				var parent = target.closest('ul');
				for (var i = 0; i < data.posts.length; i++) {
					if ((i + 1) % 3 == 0) {
						parent.append(
							'<li class="col-xs-12 col-sm-6 col-lg-4 wait_load last">' +
							'<a href="/oncourt/' + data.posts[i].post.id + '">' +
							'<img src="' + data.posts[i].image_url + '\" />' +
							'<p>' + data.posts[i].post.title + '</p>' +
							'</a>' +
							'</li>'
						);
					} else {
						parent.append(
							'<li class="col-xs-12 col-sm-6 col-lg-4 wait_load">' +
							'<a href="/oncourt/' + data.posts[i].post.id + '">' +
							'<img src="' + data.posts[i].image_url + '\" />' +
							'<p>' + data.posts[i].post.title + '</p>' +
							'</a>' +
							'</li>'
						);
					}
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