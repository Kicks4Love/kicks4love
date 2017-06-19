$(document).ready(function() {	
	if (getSourcePage() !== 'oncourt') return;
	console.log("on court");

	// set HOME menu selected
	$('#navbar .dropdown ul li').eq(1).addClass('active');

	initLoadPostHandler();
	initApplication(true, true);
});

function initLoadPostHandler() {
	var sneakerImgPath = $('.main ul li .player-card .rating img').attr('src');
	$('.to-view-more.current').one('click', function(){
		var chinese = isChinese();
		var nextPage = $('#next_page');
		var target = $(this);
		target.removeClass('current');
		target.find('span').text(chinese ? '加载中...' : 'Loading...');

		$.ajax({
			type: 'GET',
			url: '/main/get_posts?next_page=' + nextPage.val() + '&source_page=on_court',
			dataType: "json",
			success: function(data) {
				var parent = target.closest('ul');
				for (var i = 0; i < data.posts.length; i++) {
					var playerName = data.posts[i].post.player_name.split(' ');
					var hasLink = data.posts[i].post.main_images.length > 0 && data.posts[i].post.content_en.length > 0 && data.posts[i].post.content_cn.length > 0;
					var scoreStr = '<div class="rating">';
                  	for (var j = 0; j < data.posts[i].score; j++)
                        scoreStr += '<img height="12" src="' + sneakerImgPath + '"/>\n';
                  	scoreStr += '</div>';
					parent.append(
						'<li class="col-xs-12 col-sm-6 col-lg-4 wait_load">' +
                		'<div class="player-card" style="background-image:url(' + data.posts[i].image_url + ');">' +
                		'<span class="kicks-date">' + data.posts[i].post.created_at.slice(0, 10) + '</span>' + scoreStr +
                    	(hasLink ? '<a href="/oncourt/' + data.posts[i].post.id + '" class="flyout-button">' + (chinese ? '更多' : 'more') + '</a>' : '') + 
                    	'<div class="player-card-inside">' + 
                    	(hasLink ? '<a href="/oncourt/' + data.posts[i].post.id + '"">' : '') + 
                        '<div class="player-name"><span>' + (playerName[0] === undefined ? '' : playerName[0]) + '</span><br><b>' + (playerName[1] === undefined ? '' : playerName[1]) + '</b></div>' +
                        (hasLink ? '</a>' : '') +
                        '<div class="player-info">' + data.posts[i].post.title + '</div>' +
                    	'</div></div></li>'
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