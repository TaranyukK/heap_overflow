import consumer from "./consumer";

consumer.subscriptions.create('QuestionsChannel', {
  connected: function() {
    return this.perform('follow');
  },
  received: function (data) {
    let parsedData = JSON.parse(data);

    const questionHtml = `
      <div class="card mb-3">
        <div class="card-body">
          <p>rating: ${parsedData.rating}</p>
          <h2 class="card-title">
            <a href="/questions/${parsedData.id}">${parsedData.title}</a>
          </h2>
          <p class="card-text">${parsedData.body}</p>
        </div>
      </div>
    `

    $('.questions').append(questionHtml);
  }
})
