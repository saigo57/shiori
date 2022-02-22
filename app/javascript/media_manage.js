$(function() {
  LOADING_HTML = `
    <div id="loading-icon">
      <img src="/loading.gif" width="40" height="40" alt="Now Loading..." />
    </div>
  `
  $('.jscroll').jscroll({
    contentSelector: '.media_manage_list',
    nextSelector: 'span.next:last a',
    padding: 20,
    loadingHtml: LOADING_HTML
  });

  $('.media_manage-edit-thumbnail').click(function(){
    $('.media_manage-edit-thumbnail-field').click();
  });

  $('.media_manage-edit-thumbnail-field').change(function(){
    $('.edit_media_manage').submit();
  });

  $('.keyboard-input-title').click(function() {
    $('.keyboard-input-section').toggleClass('hide');
  });
  $('#begin-time-input-select_hour').change(function(e) {
    $('input[name="begin-time-input-hour"]').val($(e.target).val()) 
  });
  $('#begin-time-input-select_min').change(function(e) {
    $('input[name="begin-time-input-min"]').val($(e.target).val()) 
  });
  $('#begin-time-input-select_sec').change(function(e) {
    $('input[name="begin-time-input-sec"]').val($(e.target).val()) 
  });
  $('#end-time-input-select_hour').change(function(e) {
    $('input[name="end-time-input-hour"]').val($(e.target).val()) 
  });
  $('#end-time-input-select_min').change(function(e) {
    $('input[name="end-time-input-min"]').val($(e.target).val()) 
  });
  $('#end-time-input-select_sec').change(function(e) {
    $('input[name="end-time-input-sec"]').val($(e.target).val()) 
  });
});
