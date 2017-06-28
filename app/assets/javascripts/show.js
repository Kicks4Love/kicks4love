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

  document.getElementById('tieba-share').onclick = function() {
    var imgs = document.querySelector('meta[property="og:image"]').content.replace(/^https:\/\//i, 'http://');;
    window.open('http://tieba.baidu.com/f/commit/share/openShareApi?' + jQuery.param({url: document.URL, title: document.title, pic: imgs}));
  }

  document.getElementById('twitter-share').onclick = function() {
    window.open('https://twitter.com/intent/tweet?'+ jQuery.param({text: document.title, url: document.URL, hashtags: 'kicks4love'}));
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
  var pathArray = window.location.pathname.split('/');
  var cookieName = pathArray[1] + '-' + pathArray[2];
  if (getCookie(cookieName)) return;
  var ratingSet = false;
  var rate = 0;
  var chinese = isChinese();
  var sneakerblackImgPath = $('#sneakerblack').val();
  var sneakergrayImgPath = $('#sneakergray').val();
  $('.new-rating').removeClass('hide');
  $('.new-rating img').on('click mouseover', function(event) {
    $('.new-rating img').prop('src', sneakergrayImgPath);
    $(this).prevAll('img').addBack().prop('src', sneakerblackImgPath);
    if (event.type == 'click') {
      rate = $(this).data().rate;
      ratingSet = true;
      $('#rate-btn').html(chinese ? '确认<i class="fa fa-hand-pointer-o" aria-hidden="true"></i>' : 'Confirm<i class="fa fa-hand-pointer-o" aria-hidden="true"></i>');
    } else if (ratingSet) 
      rate = $(this).data().rate;
  });
  $('.new-rating img').on('mouseout', function() {
    if (ratingSet) return;
    $('.new-rating img').prop('src', sneakergrayImgPath);
  });
  $('#rate-btn').click(function() {
    if (!ratingSet) return;
    $('.new-rating img').unbind('click mouseover');
    var token = $(this).data().token;
    $(this).replaceWith('<i class="fa fa-spinner fa-pulse fa-lg fa-fw"></i>');
    $.ajax({
      type: 'POST',
      url: '/main/post_rating',
      data: {source_page: getSourcePage(), id: $('#post_id').val(), score: rate},
      headers: {'X-CSRF-Token': token},
      dataType: 'json',
      success: function(data) { 
        $('.new-rating .fa.fa-spinner').replaceWith(chinese ? '谢谢~' : 'Thank You~');
        var rateDisplay = $('.rating img');
        rateDisplay.prop('src', sneakergrayImgPath);
        rateDisplay.slice(0, data.score).prop('src', sneakerblackImgPath);
        var rateText = $('.rating span').text();
        $('.rating span').text(rateText.replace(/[0-9]/g, data.count));
        setCookie(cookieName, 'rated', 1);
      }
    });
  });
}