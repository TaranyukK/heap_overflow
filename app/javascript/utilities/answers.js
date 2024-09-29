$(document).on('turbolinks:load', function() {
  $('.answers').on('click', '.edit-answer-link', function(e) {
    e.preventDefault();
    $(this).hide();
    $('.delete-answer-link').hide();
    const answerId = $(this).data('answerId');
    $(`form#edit-answer-${answerId}`).removeClass('hidden');
  })
});
