$(document).ready(function() {
  initOldPostRemoval();
  initTooltip();
});

function initOldPostRemoval() {
  var table =  $('table:visible > tbody > tr');
  $("#remove-old").click(function() {
    var self = $(this);
    $.ajax({
	  type: 'GET',
      url: '/admin/rumor_posts/remove_old.json',
      dataType: "json",
      success: function(data) {
        self.addClass("disabled");
        table.each(function() {
          row = $(this).context;
          for (var i = 0; i < data.length; i++) {
            if (row.cells[1].textContent == data[i].title_en) {
              $(row).fadeOut();
              break;
            }
          }
        });
        self.text('All old posts deleted!')
      },
      error: function() { alert('Something wrong while try to delete the old posts. Please try again'); }
    });
  })
}

function initTooltip() {
  $('#rumor_post_content_en').add('#rumor_post_content_cn').tooltip().off("mouseover mouseout");
}