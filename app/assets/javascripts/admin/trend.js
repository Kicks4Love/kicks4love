$(document).ready(function() {
  initOldPostRemoval();
  initTooltip();
  initParagraphIndicator();
});

function initOldPostRemoval() {
  $("#remove-old").click(function() {
    var self = $(this);
    $.ajax({
			type: 'GET',
      url: '/admin/trend_posts/remove_old.json',
      dataType: "json",
      success: function(data) {
        self.addClass("disabled");
        var table =  $('table:visible > tbody > tr');
        table.each(function() {
          var row = $(this);
          for (var i = 0; i < data.length; i++) {
            if (row.data().id == data[i].id) {
              row.fadeOut();
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
  $('#trend_post_content_en').add('#trend_post_content_cn').tooltip().off("mouseover mouseout");
}

function initParagraphIndicator() {
  $('#trend_post_content_en').keyup(function(event) {
    if (event.which == 13 || !$(this).val()) $(this).val($(this).val() + NEW_PARAGRAPH);
  });
  $('#trend_post_content_cn').keyup(function(event) {
    if (event.which == 13 || !$(this).val()) $(this).val($(this).val() + NEW_PARAGRAPH);
  });
  $('#trend_post_content_en').add('#trend_post_content_cn').keyup();
}