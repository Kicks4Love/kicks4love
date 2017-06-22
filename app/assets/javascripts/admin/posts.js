$(document).ready(function() {
  if ($('#subscribers-dialog').length) initDialog();
	$('#post_pointer_type').change(function() {
		refreshPosts($(this).val().toLowerCase());
	});
	$('#post_pointer_type').trigger('change');
});

function initDialog() {
  var dialog = $('#subscribers-dialog');
  dialog.removeAttr('style');
  dialog.dialog({
    autoOpen: false,
    maxHeight: 350
  });
  $('#view-all-subscribers').click(function(event) { 
    event.preventDefault();
    dialog.dialog('open'); 
  });
  $('.delete-subscriber').click(function(event) {
    event.preventDefault();
    let $this = $(this)
    $this.parent('.row').remove();
    $.ajax({
      url: $this.attr('href'),
      type: 'DELETE'
    });
  });
}

function refreshPosts(postType) {
	$.ajax({
		type: 'GET',
      url: '/admin/posts/get_posts?type=' + postType,
      dataType: "json",
      success: function(data) {
         var targetSelect = $('#post_pointer_id');
         targetSelect.empty();
         data.forEach(function(entry) {
         	targetSelect.append($("<option/>", {
            value: entry.id,
            text: entry.title_en
    		   }));
        });
      }
	});
}