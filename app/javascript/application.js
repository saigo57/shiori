import RailsUjs from '@rails/ujs';
RailsUjs.start();

$(function() {
  document.body.addEventListener('ajax:error', function(event) {
    toastr.error('サーバーとの通信に失敗しました');
  })
});
