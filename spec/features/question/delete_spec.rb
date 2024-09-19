require 'rails_helper'

feature 'Author can delete his question', %q{
  In order to remove unnecessary question
  As an author of question
  I'd like to be able to delete my question
} do
  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'Author deletes his question' do
    sign_in(user)
    visit question_path(question)

    click_on 'delete'

    expect(page).to_not have_content question.title
    expect(page).to_not have_content question.body
  end

  scenario 'Non-author tries to delete question' do
    sign_in(user2)
    visit question_path(question)

    expect(page).to_not have_link 'delete'
  end
end
