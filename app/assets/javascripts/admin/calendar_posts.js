$(document).ready(function() {
	try {
		$('#calendar_post_release_date').datepicker({
			dateFormat: 'yy-mm-dd'
		});
	} catch(e) {
		var container = $('.container');
		container.empty()
		container.text('Error occur, please refresh page to continue');
	} 
});