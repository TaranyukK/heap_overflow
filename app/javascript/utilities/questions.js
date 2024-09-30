$(document).on('turbolinks:load', function() {
  $('.question').on('click', '.edit-question-link', function(e) {
    e.preventDefault();
    $('.question-action-links').hide();
    $('form#edit-question').removeClass('hidden');
  })
});
