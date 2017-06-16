$(document).ready(function() {
	initApplication(true, true);
  initRating();

	document.getElementById('facebook-share').onclick = function() {
  	FB.ui({
    		method: 'share',
    		href: document.URL,
  	}, function(response){});
	} 

	document.getElementById('weibo-share').onclick = function() {
    var imgs = document.querySelector('meta[property="og:image"]').content;
		window.open('http://service.weibo.com/share/share.php?' + jQuery.param({url: document.URL, ralateUid: weiboUId, title: document.title, pic: imgs}));
	}

	document.getElementById('copy-share').onclick = function() {
		var text = document.createElement('input');
		text.value = document.URL;
		document.body.appendChild(text);
		text.select();
		document.execCommand('copy');
		text.remove();
		this.innerHTML = '<i class="fa fa-link fa-lg" aria-hidden="true"></i> ' + (isChinese() ? '已复制' : 'Copied!')
	}
});

function initRating() {
  var ratingSet = false;
  var rate = 0;
  $('.new-rating .fa-heart').on('click mouseover', function(event) {
    $('.new-rating .fa-heart').css('color', 'lightgray');
    $(this).prevAll('.fa-heart').addBack().css('color', 'pink');
    if (event.type == 'click') {
      rate = $(this).data().rate;
      ratingSet = true;
    } else if (ratingSet) 
      rate = $(this).data().rate;
  });
  $('.new-rating .fa-heart').on('mouseout', function() {
    if (ratingSet) return;
    $('.new-rating .fa-heart').css('color', 'lightgray');
  });
  $('#rate-btn').click(function() {
    if (!ratingSet) return;
    $(this).replaceWith('<i class="fa fa-spinner fa-pulse fa-lg fa-fw"></i>');
  });
}