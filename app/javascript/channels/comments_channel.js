import consumer from "./consumer";

consumer.subscriptions.create({
    channel: 'CommentsChannel', commentable: gon.commentable
  },
  {
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
    console.log(parsedData);

    $(`#${parsedData.commentable_type.toLowerCase()}-id-${parsedData.commentable_id} .comments`).append(commentHtml);
  }
})
