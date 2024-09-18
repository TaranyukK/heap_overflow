require 'rails_helper'

feature 'User can write an answer to a question', %q{
  In order to help solve a problem
  As an authenticated user
  I'd like to be able to write an answer on the question's page
} do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'User writes a valid answer' do
    fill_in 'Body', with: 'My answer'
    click_on 'Answer'

    expect(page).to have_content 'My answer'
  end

  scenario 'User writes an invalid answer' do
    click_on 'Answer'

    expect(page).to have_content "Body can't be blank"
  end
end
