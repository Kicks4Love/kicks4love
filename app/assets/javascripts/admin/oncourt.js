$(document).ready(function() {
  initOldPostRemoval();
});

function initOldPostRemoval() {
  $("#remove-old").click(function() {
    var self = $(this);
    $.ajax({
			type: 'GET',
      url: '/admin/on_court_posts/remove_old.json',
      dataType: "json",
      success: function (data) {
        self.addClass("disabled");
        var table =  $('table:visible > tbody > tr');
        table.each(function() {
          row = $(this).context;
          for (var i = 0; i < data.length; i++) {
            if (row.cells[0].textContent == data[i].title_en) {
              $(row).fadeOut();
              break;
            }
          }
        });
        self.text('All old posts deleted!');
      },
      error: function() { alert('Something wrong while try to delete the old posts. Please try again'); }
    });
  })
}
