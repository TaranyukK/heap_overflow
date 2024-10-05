require 'rails_helper'

feature 'Author can delete files in his answer', %q{
  In order to remove unnecessary files in answer
  As an author of answer
  I'd like to be able to delete files in my answer
}, js: true do
  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, :with_file, question: question, user: user) }

  scenario 'Author deletes his answer' do
    sign_in(user)
    visit question_path(question)

    within '.answer-files' do
      accept_alert do
        click_on 'delete'
      end
    end

    expect(page).to_not have_link answer.files.first.blob.filename
  end

  scenario 'Non-author tries to delete answer' do
    sign_in(user2)
    visit question_path(question)

    within '.answer-files' do
      expect(page).to_not have_link 'delete'
    end
  end
end
