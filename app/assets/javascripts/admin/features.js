$(document).ready(function() {
  initOldPostRemoval();
  initPostComposition();
  initTooltip();
  initFormSubmit();
});

function initOldPostRemoval() {
  $('#remove-old').click(function() {
    var self = $(this);
    $.ajax({
      type: 'GET',
      url: '/admin/feature_posts/remove_old.json',
      dataType: "json",
      success: function(data) {
        var table =  $('table:visible > tbody > tr');
        self.addClass("disabled");
        table.each(function() {
          row = $(this).context;
          for (var i = 0; i < data.length; i++) {
            if (row.cells[1].textContent == data[i].title_en) {
              $(row).fadeOut();
              break;
            }
          }
          self.text('All old posts deleted!');
        });
      },
      error: function() { alert('Something wrong while try to delete the old posts. Please try again'); }
    });
  });
}

/* function that allow user to compose the post's images and contents order */
function initPostComposition() {
  var enCount = cnCount = 0;
  var displayParagraph = $('#number-paragraph');
  var displayImage = $('#number-image');
  var imageCount = parseInt($('#number-image').text());
  var postComposition = $('#post-composition');
  var table = postComposition.find('table');

  $('#feature_post_content_en').keyup(function() {
    enCount = $(this).val().split(/\r|\n/).length;
    displayParagraph.text(enCount + ' / ' + cnCount);
    updateCompositionTable();
  });

  $('#feature_post_content_cn').keyup(function() {
    cnCount = $(this).val().split(/\r|\n/).length;
    displayParagraph.text(enCount + ' / ' + cnCount);
    updateCompositionTable();
  });

  $('#feature_post_content_en').add('#feature_post_content_cn').keyup();

  $('#feature_post_main_images').change(function() {
    imageCount = $(this).get(0).files.length;
    displayImage.text(imageCount);
    $('.main-images').remove();
    for (var i = 0; i < imageCount; i++)
      $('<input>').attr({
        type: 'hidden',
        class: 'main-images',
        value: $(this).get(0).files[i].name
      }).appendTo(postComposition);
    updateCompositionTable();
  });

  function updateCompositionTable() {
    var total = enCount + imageCount;
    var selectString = '<select>';

    for (var i = 1; i <= total; i++)
      selectString += '<option value="' + i + '">' + i + '</option>';
    selectString += '</select>';

    table.empty();

    $('.main-images').each(function(index) {
      table.append('<tr data-type="image"><td>' + $(this).val() + '</td><td>' + selectString + '</td></tr>');
    });

    for (var i = 1; i <= enCount; i++)
      table.append('<tr data-type="paragraph"><td>Paragraph ' + i + '</td><td>' + selectString + '</td></tr>')
  }
}

function initFormSubmit() {
  $('.new_feature_post, .edit_feature_post').submit(function(event) {
    event.preventDefault();

    var postCompositionData = {};
    var table = document.querySelector('#post-composition table');
    for (var i = 0; i < table.rows.length; i++) {
      var row = table.rows[i];
      postCompositionData[$(row.cells[1]).find('select').find(':selected').val()] = {
        type: $(row).data('type')
      }
    }

    console.log(postCompositionData);

    return false;
  });
}

function initTooltip() {
  $('#feature_post_content_en').add('#feature_post_content_cn').tooltip().off("mouseover mouseout");
}