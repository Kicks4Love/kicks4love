$(document).ready(function() {
    if (getSourcePage() !== 'streetsnap') return;
    console.log("streetsnap");

    // set STREETSNAP menu selected
	$('#navbar .dropdown ul li').eq(2).addClass('active');
	
	initApplication(true, true);
	$('.snap-card').on('click touchstart', function() { $(this).toggleClass('active'); });
});