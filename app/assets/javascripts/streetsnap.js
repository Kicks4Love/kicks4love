$(document).ready(function() {
    if (getSourcePage() !== 'streetsnap') return;
    console.log("streetsnap");

    // set STREETSNAP menu selected
	$('#navbar .dropdown ul li').eq(4).addClass('active');
	
	initApplication(true, true);
	$('.snap-card').on('touchstart', function() { 
		$(this).toggleClass('active'); 
		$(this).parent().siblings().find('.snap-card').removeClass('active');
	});
});