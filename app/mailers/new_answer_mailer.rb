class NewAnswerMailer < ApplicationMailer
  def new_answer(answer, user)
    @answer = answer

    mail to: user.email, subject: "New Answer for #{@answer.question.title}"
  end
end
