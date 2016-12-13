// JavaScript Document

$(function(){
	$('.navbar-toggle').click(function(){
		$('.navbar-collapse ul').addClass('down');
		if($('.navbar-collapse ul').hasClass('in')){
			$('.collapse ul').slideUp();
			$('.header').animate({
				'margin-top': '0px',
			})
			$('.navbar-collapse ul').removeClass('in');
			$('.navbar-collapse ul').removeClass('down');
		}

		if($('.navbar-collapse ul').hasClass('down')){
			$('.collapse ul').css('background','#F8F8F8').css('width','100%').css('position','absolute').css('top','70px').css('left','15px').slideDown();
			$('.header').animate({
				'margin-top': '40px',
			})
			$('.collapse ul li').eq(0).css('display','none');
			$('.navbar-collapse ul').addClass('in');
		}

	});
	initLoadPostHandler();
	/*--点击加载-lazyload--*/
	function initLoadPostHandler() {
		var view_more = $('.to-view-more');
		var nextPage = $('#next_page');
		view_more.click(function(){
			view_more.find('span').text('Loading...');
			$.ajax({
					type: 'GET',
					url: '/main/get_posts?next_page=' + nextPage.val() + '&source_page=on_court',
					dataType: "json",
					success: function(data) {
						var parent = $('.clearfix');
						for (var i = 0; i < data.posts.length; i++) {
							if ((i + 1) % 3 == 0) {
								parent.append(
									'<li class="wait_load last">' +
			            	'<a href="#">' +
			                    '<img src="assets/on_court_post/' + data.posts[i].cover_image + '\" />' +
			                    '<p>' + data.posts[i].title_en + '</p>' +
			                '</a>' +
			            '</li>'
								);
							} else {
								parent.append(
									'<li class="wait_load">' +
			            	'<a href="#">' +
			                    '<img src="assets/on_court_post/' + data.posts[i].cover_image + '\" />' +
			                    '<p>' + data.posts[i].title_en + '</p>' +
			                '</a>' +
			            '</li>'
								);
							}
						}
						if (!data.no_more) {
							parent.append('<div class="to-view-more"><span>Click To View More</span></div>');
							nextPage.val(parseInt(nextPage.val()) + 1);
						}
						view_more.fadeOut();
						$('.wait_load').fadeIn(1000);
						initLoadPostHandler();
			}
		});
	 })
	}

})
