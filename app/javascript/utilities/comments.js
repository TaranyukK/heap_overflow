$(document).on('turbolinks:load', function() {
  $('.comments').on('click', '.edit-comment-link', function(e) {
    e.preventDefault();
    $(this).hide();
    $('.delete-comment-link').hide();
    const commentId = $(this).data('commentId');
    $(`form#edit-comment-${commentId}`).removeClass('hidden');
  })
});
