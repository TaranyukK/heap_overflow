require 'rails_helper'

feature 'Author can edit his comment', "
  In order to edit comment
  As an author of comment
  I'd like to be able to edit my comment
" do
  given!(:question) { create(:question) }

  describe 'Authenticated user', :js do
    given(:user) { create(:user) }
    given!(:comment) { create(:comment, commentable: question, user:) }

    background do
      sign_in(user)
      visit question_path(question)
    end

    context 'users comment' do
      scenario 'edit comment' do
        within "#comment-id-#{comment.id}" do
          click_on 'edit'

          fill_in 'Your comment', with: 'edited comment'
          click_on 'Save'

          expect(page).to have_no_content comment.body
          expect(page).to have_content 'edited comment'
          expect(page).to have_no_element 'input'
        end
      end

      scenario 'edit comment with errors' do
        within "#comment-id-#{comment.id}" do
          click_on 'edit'

          fill_in 'Your comment', with: ''
          click_on 'Save'

          expect(page).to have_content comment.body
          expect(page).to have_element 'input'
        end
      end
    end

    context "someone else's comment" do
      given(:another_user) { create(:user) }
      given!(:comment) { create(:comment, commentable: question, user: another_user) }

      scenario 'edit comment to the question' do
        within "#comment-id-#{comment.id}" do
          expect(page).to have_no_link 'edit'
        end
      end
    end
  end

  describe 'Unauthenticated user' do
    given!(:comment) { create(:comment, commentable: question) }

    scenario 'edit comment' do
      visit question_path(question)

      within "#comment-id-#{comment.id}" do
        expect(page).to have_no_link 'edit'
      end
    end
  end
end
