class NewAnswerService
  def send_notification(answer)
    answer.question.subscriptions.where.not(user: answer.user).find_each do |subscription|
      NewAnswerMailer.new_answer(answer, subscription.user).deliver_later
    end
  end
end
