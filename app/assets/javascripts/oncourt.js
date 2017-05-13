$(document).ready(function() {	
	if (getSourcePage() !== 'oncourt') return;

	// set HOME menu selected
	$('#navbar .dropdown ul li').eq(1).addClass('active');
	console.log("on court");

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
					parent.append(
						'<li class="col-xs-12 col-sm-6 col-lg-4 wait_load">' +
                		'<div class="player-card" style="background-image:url(' + data.posts[i].image_url + ');">' +
                    	'<a href="/oncourt/' + data.posts[i].post.id + '" class="flyout-button">' + (chinese ? '更多' : 'more') + '</a>' + 
                    	'<div class="player-card-inside">' + 
                        '<div class="player-name"><span>' + data.posts[i].post.player_name.split(' ')[0] + '</span><br><b>' + data.posts[i].post.player_name.split(' ')[1] + '</b></div>' +
                        '<div class="player-info">' + data.posts[i].post.title + '</div>' +
                    	'</div></div></li>'
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