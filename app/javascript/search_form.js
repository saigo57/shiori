$(function() {
  $('#sort_target').change(function(){
    $(`#search-form-id`).submit();
  });

  $('.search-checkbox').change(function(){
    $(`#search-form-id`).submit();
  });

  $('.search-sort-order').click(function(){
    var input_field = $('#search-form-id').children('input[name="sort_order"]');
    var curr_order = input_field.val();
    var next_order;
    if ( curr_order == 'asc' ) {
      next_order = 'desc';
    }
    else {
      next_order = 'asc';
    }
    input_field.val(next_order);
    $(`#search-form-id`).submit();
  });
});
