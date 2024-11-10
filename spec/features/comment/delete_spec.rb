require 'rails_helper'

feature 'Author can delete his comment', "
  In order to remove unnecessary comment
  As an author of comment
  I'd like to be able to delete my comment
", :js do
  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given(:question) { create(:question) }
  given!(:comment) { create(:comment, commentable: question) }

  scenario 'Author deletes his comment' do
    sign_in(user)
    visit question_path(question)

    within ".comments #comment-id-#{comment.id}" do
      accept_alert do
        click_on 'delete'
      end
    end

    expect(page).to have_no_content comment.body
  end

  scenario 'Non-author tries to delete answer' do
    sign_in(user2)
    visit question_path(question)

    within ".comments #comment-id-#{comment.id}" do
      expect(page).to have_no_link 'delete'
    end
  end
end
