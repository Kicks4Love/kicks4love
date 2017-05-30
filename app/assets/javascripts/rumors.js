$(document).ready(function() {
    if (getSourcePage() !== 'rumors') return;
    console.log("rumors");

    // set RUMORS menu selected
	$('#navbar .dropdown ul li').eq(2).addClass('active');
	
	initApplication(true, true);
});