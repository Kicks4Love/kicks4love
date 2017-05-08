$(document).ready(function() {
	$('#post_pointer_type').change(function() {
		refreshPosts($(this).val().toLowerCase());
	});
	$('#post_pointer_type').trigger('change');
});

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
