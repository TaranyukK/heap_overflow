require 'rails_helper'

feature 'Author can delete files in his answer', "
  In order to remove unnecessary files in answer
  As an author of answer
  I'd like to be able to delete files in my answer
", :js do
  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, :with_file, question: question, user: user) }

  scenario 'Author deletes file in his answer' do
    sign_in(user)
    visit question_path(question)

    within '.answer-files' do
      accept_alert do
        click_on 'delete'
      end
    end

    expect(page).to have_no_link answer.files.first.blob.filename
  end

  scenario 'Non-author tries to delete file in answer' do
    sign_in(other_user)
    visit question_path(question)

    within '.answer-files' do
      expect(page).to have_no_link 'delete'
    end
  end
end
