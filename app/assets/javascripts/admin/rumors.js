$(document).ready(function() {
  initOldPostRemoval();
  if ($('#more-dialog').length) initDialog();
  initTooltip();
  initParagraphIndicator();
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
  });
}

function initDialog() {
  var dialog = $('#more-dialog');
  dialog.dialog({autoOpen: false});
  $('.more-dialog-btn').click(function(event) {
    event.preventDefault();
    data = $(this).data().rates;
    dialog.empty();
    context = '';
    for (var key in data)
      context += '<p>' + key + ': ' + data[key] + '</p>';
    dialog.append(context);
    dialog.dialog('open');
  });
}

function initTooltip() {
  $('#rumor_post_content_en').add('#rumor_post_content_cn').tooltip().off("mouseover mouseout");
}

function initParagraphIndicator() {
  $('#rumor_post_content_en').keyup(function(event) {
    var text = $(this).val();
    if (event.which == 13 || !text) {
      var selectPos = this.selectionStart;
      $(this).val(text.substring(0, selectPos) + NEW_PARAGRAPH + text.substring(selectPos));
    }
  });
  $('#rumor_post_content_cn').keyup(function(event) {
    var text = $(this).val();
    if (event.which == 13 || !text) {
      var selectPos = this.selectionStart;
      $(this).val(text.substring(0, selectPos) + NEW_PARAGRAPH + text.substring(selectPos));
    }
  });
  $('#rumor_post_content_en').add('#rumor_post_content_cn').keyup();
}