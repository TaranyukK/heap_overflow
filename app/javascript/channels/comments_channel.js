import consumer from "./consumer";

consumer.subscriptions.create('CommentsChannel', {
  connected: function() {
    return this.perform('follow');
  },
  received: function (data) {
    console.log(data)
    const commentHtml = `
      <div class="card mb-3" id="comment-id-${data.id}">
        <div class="card-body">
          <p class="card-text">${data.body}</p>
        </div>
      </div>
    `

    $('.comments').append(commentHtml);
  }
})
