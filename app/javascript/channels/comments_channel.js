import consumer from "./consumer";

consumer.subscriptions.create({ channel: 'CommentsChannel', question_id: gon.question_id }, {
  connected: function() {
    return this.perform('follow');
  },
  received: function (data) {
    let parsedData = JSON.parse(data);

    const commentHtml = `
      <div class="card mb-3" id="comment-id-${parsedData.id}">
        <div class="card-body">
          <p class="card-text">${parsedData.body}</p>
        </div>
      </div>
    `

    $(`#${parsedData.commentable_type.toLowerCase()}-id-${parsedData.commentable_id} .${parsedData.commentable_type.toLowerCase()}-comments`).append(commentHtml);
  }
})
