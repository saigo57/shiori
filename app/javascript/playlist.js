$(function() {
  $('body').on('change', '.playlist-checkbox', function() {
    prefix = 'playlist-checkbox-';
    attr_id = $(this).attr('id');
    if ( attr_id.indexOf(prefix) !== 0 ) {
      alert("[bug] playlist-checkbox prefix error");
    }

    var playlist_id = attr_id.substr(prefix.length);

    $(`#playlist-submit-${playlist_id}`).click();
  });

  function togglePlaylistTitle() {
    $('.playlist-title').toggleClass("active");
    $('.edit_playlist').toggleClass("active");
  }

  $('.playlist-title').on('click', 'a', togglePlaylistTitle);
  $('.edit_playlist').on('click', 'a', togglePlaylistTitle);
});
