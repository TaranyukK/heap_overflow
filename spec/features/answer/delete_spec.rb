require 'rails_helper'

feature 'Author can delete his answer', %q{
  In order to remove unnecessary answer
  As an author of answer
  I'd like to be able to delete my answer
} do
  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Author deletes his answer' do
    sign_in(user)
    visit question_path(question)

    click_on 'delete'

    expect(page).to_not have_content answer.body
  end

  scenario 'Non-author tries to delete answer' do
    sign_in(user2)
    visit question_path(question)

    expect(page).to_not have_link 'delete'
  end
end
