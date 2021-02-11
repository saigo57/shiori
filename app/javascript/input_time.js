const isNumber = function(value) {
  return ((typeof value === 'number') && (isFinite(value)));
};

const calcTimeInput = function(prefix) {
  hour = $(`input[name="${prefix}-time-input-hour"]`).val() - 0
  min  = $(`input[name="${prefix}-time-input-min"]`).val() - 0
  sec  = $(`input[name="${prefix}-time-input-sec"]`).val() - 0
  if ( !isNumber(hour) ) hour = 0;
  if ( !isNumber(min) ) min = 0;
  if ( !isNumber(sec) ) sec = 0;
  return hour * 3600 + min * 60 + sec;
};

$(function() {
  $('.edit_media_manage').submit(function() {
    sec_calc = calcTimeInput('length');
    $('.edit_media_manage').find('input[name="media_manage[media_sec]"]').val(sec_calc);
  });

  $('#timespan_submit_id').click(function(){
    begin_sec_calc = calcTimeInput('begin');
    end_sec_calc = calcTimeInput('end');
    $('#timespan_form_id').find('input[name="begin_sec"]').val(begin_sec_calc)
    $('#timespan_form_id').find('input[name="end_sec"]').val(end_sec_calc)

    $('#timespan_form_id').submit();
  });
});
