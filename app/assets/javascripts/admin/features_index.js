$(document).ready(function() {
  initOldPostRemoval(this);
});
function initOldPostRemoval() {
  var table =  $('table:visible > tbody > tr');
  var row_count = table.length - 1;
  var rows_removed = 0;
  var btn = $(".btn-danger")
  btn.click(function() {
    $.ajax({
      context: document.body,
			type: 'GET',
            url: '/admin/feature_posts/remove_old.json',
            dataType: "json",
            success: function(data) {
            btn.addClass("disabled");
            table.each(function() {
                row = $(this).context;
                for (var i = 0; i < data.length; i++) {
                  if (row.cells[1].textContent == data[i].title_en) {
                    $(this).fadeOut();
                    rows_removed++;
                    break;
                  }
                }
              });
            }
          });
    $(this).text('All old posts deleted!');
  })
}
