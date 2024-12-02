require 'rails_helper'

feature 'Author can delete his answer', "
  In order to remove unnecessary answer
  As an author of answer
  I'd like to be able to delete my answer
", :js do
  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Author deletes his answer' do
    sign_in(user)
    visit question_path(question)
    accept_alert do
      click_on 'delete'
    end

    expect(page).to have_no_content answer.body
  end

  scenario 'Non-author tries to delete answer' do
    sign_in(other_user)
    visit question_path(question)

    expect(page).to have_no_link 'delete'
  end
end
