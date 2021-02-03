$(function() {
  $('#sort_target').change(function(){
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
