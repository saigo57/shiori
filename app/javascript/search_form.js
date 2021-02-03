$(function() {
  $('.sort-select-item').click(function(){
    prefix = 'sort-select-item-';
    attr_id = $(this).attr('id');
    if ( attr_id.indexOf(prefix) !== 0 ) {
      alert("[bug] playlist-checkbox prefix error");
    }

    var selected_id = attr_id.substr(prefix.length);
    $('#search-form-id').children('input[name="sort_target"]').val(selected_id)

    $(`#search-form-id`).submit();
  });

  $('.search-checkbox').change(function(){
    $(`#search-form-id`).submit();
  });

  $('.search-sort-order').click(function(){
    var input_field = $('#search-form-id').children('input[name="sort_order"]');
    var curr_order = input_field.val() - 0;
    var next_order = (curr_order + 1) % 2;
    input_field.val(next_order);
    $(`#search-form-id`).submit();
  });
});
