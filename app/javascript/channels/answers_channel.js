import consumer from "./consumer";

consumer.subscriptions.create(
  { channel: 'AnswersChannel', question_id: gon.question_id },
  {
  connected: function() {
    return this.perform('follow');
  },
  received: function (data) {
    let parsedData = JSON.parse(data);

    const answerHtml = `
      <div class="card mb-3" id="answer-id-${parsedData.id}">
        <div class="card-body">
          <div class="vote vote-Answer-31">
            <div class="vote-errors"></div>
            <p>Votes:</p>
            <div class="total-votes">${parsedData.rating}</div>
          </div>
          <p class="card-text">${parsedData.body}</p>
        </div>
      </div>
    `;

    $('.answers').append(answerHtml);
  }
})
