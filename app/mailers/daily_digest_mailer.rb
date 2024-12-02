class DailyDigestMailer < ApplicationMailer
  def digest(user)
    @questions = Question.all.where(created_at: 1.day.ago.all_day)

    mail to: user.email, subject: 'Here is som new questions'
  end
end
