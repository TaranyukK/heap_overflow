require 'rails_helper'

feature 'Author can delete files in his question', %q{
  In order to remove unnecessary files in question
  As an author of question
  I'd like to be able to delete files in my question
} do
  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given!(:question) { create(:question, :with_file, user: user) }

  scenario 'Author deletes his question', js: true do
    sign_in(user)
    visit question_path(question)

    within '.question-files' do
      accept_alert do
        click_on 'delete'
      end
    end

    expect(page).to_not have_link question.files.first.blob.filename
  end

  scenario 'Non-author tries to delete question' do
    sign_in(user2)
    visit question_path(question)

    within '.question-files' do
      expect(page).to_not have_link 'delete'
    end
  end
end
