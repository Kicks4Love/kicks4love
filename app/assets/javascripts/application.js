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
const emailRegex = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;

function initApplication(showPendant, showLanguage) {
    // language setting
    var languageSet = $('#language-set').val().length > 0;
    var chinese = isChinese();
  	if (!languageSet && showLanguage) $('#language-modal').modal('show');
  	$('#language-form').submit(function() {
  		if (languageSet && chinese && this.submited.includes('chinese'))
  			return false;
  		if (languageSet && !chinese && this.submited.includes('english'))
  			return false;
  	});

    // logo pendant animation
    if (showPendant) {
        var logoPendant = $('.logo-pendant');
        setTimeout(function() {
            logoPendant.addClass('hide-small');
            logoPendant.removeAttr('style');
        }, 1000);
        logoPendant.click(function() {
            if ($(this).attr('style') === undefined)
                $(this).css('opacity', '0.3');
            else
                $(this).removeAttr('style');
        });
    }

    // google analytics page view send
    ga('send', 'pageview');

    // scroll to top button
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

    // subscribe setting
    var subscribeForm = $('.subscribe');
    $('.show-subscribe').on('click', function (event) {
        event.preventDefault();
        subscribeForm.addClass('show');
        subscribeForm.find('input[type="email"]').focus();
    });
    subscribeForm.on('click', 'i.fa-times', function() {subscribeForm.removeClass('show');});
    $('#signup-form').submit(function(event) {
        event.preventDefault();
        var $this = $(this);
        var subData = $this.serializeArray();
        var authToken, email;
        subData.forEach(function(param) {
            if (param.name == "authenticity_token")  authToken = param.value;
            else if (param.name == "email") email = param.value;
        });
        if (!emailRegex.test(email)) return false;
        $.post({
            url: $this.attr('action'),
            headers: {'X-CSRF-Token': authToken},
            data: subData,
            dataType: 'json'
        }).done(function() {
            $this.replaceWith('<span style="position:absolute;top:5px;padding:0 10px">' + (chinese ? '谢谢你的加入，每个星期你将会收到我们最新最火的内容' : 'Thank you for your subscription, you will receive our latest and hottest news weekly') + '</span>');
        }).fail(function() {
            alert(chinese ? '请确定你输入的邮箱是正确的，或换另一个邮箱地址' : 'Please make sure the email you entered is correct, or try another email address');
            setTimeout(function() {$.rails.enableFormElements($this);}, 500);
        });
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

function getCookie(name) {
    var value = '; ' + document.cookie;
    var parts = value.split('; ' + name + '=');
    if (parts.length == 2) return parts.pop().split(';').shift();
}

function setCookie(name, value, days) {
    var date, expires;
    if (days) {
        date = new Date();
        date.setTime(date.getTime() + (days*24*60*60*1000));
        expires = '; expires=' + date.toGMTString();
    } else
        expires = '';
    document.cookie = name + '=' + value + expires;
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