require 'rails_helper'

feature 'Author can edit his question', "
  In order to edit question
  As an author of question
  I'd like to be able to edit my question
" do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user:) }

  describe 'Authenticated user', :js do
    background { sign_in(user) }

    context 'users question' do
      background do
        visit question_path(question)
        click_on 'edit'
      end

      scenario 'edit question' do
        within '.question' do
          fill_in 'Title', with: 'Question Title'
          click_on 'Save'

          expect(page).to have_no_content question.title
          expect(page).to have_content 'Question Title'
          expect(page).to have_no_css 'textfield'
        end
      end

      scenario 'edit question with errors' do
        within '.question' do
          fill_in 'Body', with: ''
          click_on 'Save'

          expect(page).to have_content question.body
          expect(page).to have_css 'textarea'
        end
      end
    end

    context "someone else's question" do
      given(:another_user) { create(:user) }
      given!(:question) { create(:question, user: another_user) }

      scenario 'edit question' do
        visit question_path(question)

        within '.question' do
          expect(page).to have_no_link 'edit'
        end
      end
    end
  end

  describe 'Unauthenticated user' do
    scenario 'edit question' do
      visit question_path(question)

      within '.question' do
        expect(page).to have_no_link 'edit'
      end
    end
  end
end
