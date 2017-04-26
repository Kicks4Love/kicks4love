$(document).ready(function() {	
	initLoadPostHandler();
	setTimeout(function() { $('.logo-pendant').fadeIn('slow'); }, 1000);

	if (!$('#language').val().length)
		$('#language-modal').modal('show');

	$('#language-form').submit(function(){
    	var current_language = $('#language').val();
    	
    	if (current_language == 'cn' && this.submited.includes('chinese'))
    		return false;
    	if (current_language == 'en' && this.submited.includes('english'))
    		return false;
	});

    $('.not-work').click(function(event) {
        event.preventDefault();
        alert("即将来临\nComing soon");
    });
});

/*--点击加载-lazyload--*/
function initLoadPostHandler() {
	var viewMore = $('.to-view-more');
	var nextPage = $('#next_page');
	viewMore.click(function(){
		viewMore.find('span').text('Loading...');
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
				viewMore.fadeOut();
				$('.wait_load').fadeIn(1000);
				initLoadPostHandler();
			}
		});
	});
}