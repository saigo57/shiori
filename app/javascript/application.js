import RailsUjs from '@rails/ujs';
RailsUjs.start();

$(function() {
  document.body.addEventListener('ajax:error', function(event) {
    M.toast({html: 'サーバーとの通信に失敗しました'});
  })
});
