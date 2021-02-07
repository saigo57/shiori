$(function() {
  LOADING_HTML = `
    <div id="loading-icon">
      <img src="loading.gif" width="40" height="40" alt="Now Loading..." />
    </div>
  `
  $('.jscroll').jscroll({
    contentSelector: '.media_manage_list',
    nextSelector: 'span.next:last a',
    padding: 20,
    loadingHtml: LOADING_HTML
  });
});
