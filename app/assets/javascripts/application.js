// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrap.min.js

var autoSlider = null;

function initApplication(showPendant, showLanguage) {
  initSignupForm();
  var languageSet = $('#language-set').val().length > 0;

	if (!languageSet && showLanguage)
		$('#language-modal').modal('show');

	$('#language-form').submit(function() {
    	var chinese = isChinese();

		if (languageSet && chinese && this.submited.includes('chinese'))
			return false;
		if (languageSet && !chinese && this.submited.includes('english'))
			return false;
	});

    if (showPendant) {
        var logoPendant = $('.logo-pendant');
        setTimeout(function() {
            logoPendant.fadeIn('slow', function() { $(this).removeAttr('style'); $(this).addClass('hide-small') });
        }, 1000);
        logoPendant.click(function() {
            if ($(this).attr('style') === undefined)
                $(this).css('opacity', '0.3');
            else
                $(this).removeAttr('style');
        });
    }

    ga('send', 'pageview');

    var scrollTopButton = $('#scroll-top');
    $(window).scroll(function() {
        if ($(this).scrollTop() > 100)
            scrollTopButton.css('bottom', '15px');
        else
            scrollTopButton.removeAttr('style');
    });
    scrollTopButton.click(function(){
        $('html, body').animate({scrollTop : 0},500);
        return false;
    });

    $('.not-work').on('click submit' ,function(event) {
        event.preventDefault();
        alert("即将来临\nComing soon");
    });
}

function getQueryParams() {
    queryDict = {};
    location.search.substr(1).split("&").forEach(function(item) {queryDict[item.split("=")[0]] = item.split("=")[1]});
    return queryDict;
}

function isChinese() {
    return $('html').attr('lang') == 'zh';
}

function getSourcePage() {
    return $('#page_source').val();
}

function initSignupForm() {
    $('.newsletter-subscribe').hide();
    let sub_email = $('#newsletter_sub').val();
    if (!sub_email) {
      $('.newsletter-subscribe').show();
      $('#signup-form').show();
      $('.subscribe-message').hide();
      $('#signup-form').submit(function(event) {
        event.preventDefault();
        let url = $(this).attr("action");
        let sub_data = $(this).serializeArray();
        let auth_token;
        sub_data.forEach(function(param) {
          if (param.name == "authenticity_token") {
            auth_token = param.value;
          }
        })
        $.post({ url: url,
                 headers: {'X-CSRF-Token': auth_token} ,
                 data: sub_data,
                 dataType: "json"
        }).done(function() {
          $('#signup-form').hide();
          $('.subscribe-message').show();
        })
        .fail(function() {
          $('#signup-form').find(':submit').prop('disabled', false).val('Submit');
        });
      });
    }
}

window.ga=window.ga||function(){(ga.q=ga.q||[]).push(arguments)};ga.l=+new Date;
ga('create', 'UA-100873227-1', 'auto');
window.fbAsyncInit = function() {
    FB.init({
        appId      : facebookAppId,
        xfbml      : true,
        version    : 'v2.9'
    });
     FB.AppEvents.logPageView();
};
(function(d, s, id){
    var js, fjs = d.getElementsByTagName(s)[0];
    if (d.getElementById(id)) {return;}
    js = d.createElement(s); js.id = id;
    js.src = "//connect.facebook.net/en_US/sdk.js";
    fjs.parentNode.insertBefore(js, fjs);
}(document, 'script', 'facebook-jssdk'));
