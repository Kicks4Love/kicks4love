$(document).ready(function() {
	try {
		if ($('#calendar_post_release_date').length) {
			$('#calendar_post_release_date').datepicker({
				dateFormat: 'yy-mm-dd'
			});
		}
	} catch(e) {
		var container = $('.container');
		container.empty()
		container.text('Error occur, please refresh page to continue');
		return;
	}
	initOldPostRemoval();
});

function initOldPostRemoval() {
  	$("#remove-old").click(function() {
  		var self = $(this);
    	$.ajax({
			type: 'GET',
        	url: '/admin/calendar_posts/remove_old.json',
        	dataType: 'json',
        	success: function(data) {
           		$(self).addClass("disabled");
           		var table = $('table:visible > tbody > tr');
            	table.each(function() {
                	var row = $(this);
                	for (var i = 0; i < data.length; i++) {
                  		if (row.data().id == data[i].id) {
                    		row.fadeOut();
                    		break;
                  		}
                	}
            	});
            	$(self).text('All old posts deleted!');
        	},
        	error: function() { alert('Something wrong while try to delete the old posts. Please try again'); }
    	});
  	});
}