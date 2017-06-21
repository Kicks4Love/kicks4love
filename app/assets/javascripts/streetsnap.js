$(document).ready(function() {
    if (getSourcePage() !== 'streetsnap') return;
    console.log("streetsnap");

    // set STREETSNAP menu selected
	$('#navbar .dropdown ul li').eq(4).addClass('active');
	
	initApplication(true, true);
	document.querySelector('.main .content').addEventListener('touchstart', function(){}, true);
});