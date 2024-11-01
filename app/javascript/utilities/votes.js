$(document).on('turbolinks:load', function() {
  $('.vote .voting').on('ajax:success', function(e) {
    let data = e.detail[0];

    let voteClass = '.vote-' + data.resource_class + '-' + data.id;

    $(voteClass + ' .total-votes').html(data.rating);
  });
});
