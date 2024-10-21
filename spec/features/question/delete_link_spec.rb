require 'rails_helper'

feature 'Author can delete links in his question', %q{
  In order to remove unnecessary links in question
  As an author of question
  I'd like to be able to delete links in my question
} do
  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given!(:question) { create(:question, :with_link, user: user) }

  scenario 'Author deletes his question', js: true do
    sign_in(user)
    visit question_path(question)

    within '.question-links' do
      accept_alert do
        click_on 'delete'
      end
    end

    expect(page).to_not have_link question.links.first.name
  end

  scenario 'Non-author tries to delete link in question' do
    sign_in(user2)
    visit question_path(question)

    within '.question-links' do
      expect(page).to_not have_link 'delete'
    end
  end
end
