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

function initApplication() {
	if (!$('#language').val().length)
		$('#language-modal').modal('show');

	$('#language-form').submit(function() {
        var languageSet = $('#language').val().length > 0;
    	var chinese = isChinese();
    	
    	if (languageSet && chinese && this.submited.includes('chinese'))
    		return false;
    	if (languageSet && !chinese && this.submited.includes('english'))
    		return false;
	});

    setTimeout(function() { $('.logo-pendant').fadeIn('slow'); }, 1000);

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
    return $('#language').val() == 'cn';
}

function getSourcePage() {
    return $('#page_source').val();
}