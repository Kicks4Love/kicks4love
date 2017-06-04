$(document).ready(function() {
    if (getSourcePage() !== 'contact') return;
	console.log("contact");

	$('.collapse').on('show.bs.collapse', function() {
	  	var otherPanels = $(this).parents('.card').siblings('.card');
    	$('.collapse', otherPanels).collapse('hide');
	});

	initApplication(false, true);
});