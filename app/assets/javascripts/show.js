$(document).ready(function() {
  	initApplication(true, true);

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