require 'rails_helper'

feature 'User can view question and its answers', %q{
  In order to get more information
  As a user
  I'd like to be able to view the question and its answers
} do
  given!(:question) { create(:question) }
  given!(:answers) { create_list(:answer, 3, question: question) }

  scenario 'User views question with answers' do
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body

    answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end
end
