require 'rails_helper'

feature 'Author can delete links in his answer', "
  In order to remove unnecessary links in answer
  As an author of answer
  I'd like to be able to delete links in my answer
", :js do
  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, :with_link, question: question, user: user) }

  scenario 'Author deletes link from answer' do
    sign_in(user)
    visit question_path(question)

    within '.answer-links' do
      accept_alert do
        click_on 'delete'
      end
    end

    expect(page).to have_no_link answer.links.first.name
  end

  scenario 'Non-author tries to delete link in answer' do
    sign_in(user2)
    visit question_path(question)

    within '.answer-links' do
      expect(page).to have_no_link 'delete'
    end
  end
end
