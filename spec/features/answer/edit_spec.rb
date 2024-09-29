require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to edit answer
  As an author of answer
  I'd like to be able to edit my answer
} do
  given!(:question) { create(:question) }

  describe 'Authenticated user', js: true do
    given(:user) { create(:user) }
    given!(:answer) { create(:answer, question:, user:) }

    background do
      sign_in(user)
      visit question_path(question)
    end

    context 'users answer' do
      scenario 'edit answer' do
        click_on 'edit'

        within '.answers' do
          fill_in 'Your answer', with: 'edited answer'
          click_on 'Save'

          expect(page).to_not have_content answer.body
          expect(page).to have_content 'edited answer'
          expect(page).to_not have_selector 'textarea'
        end
      end

      scenario 'edit answer with errors' do
        click_on 'edit'

        within '.answers' do
          fill_in 'Your answer', with: ''
          click_on 'Save'

          expect(page).to have_content answer.body
          expect(page).to have_selector 'textarea'
        end
      end
    end

    context "someone else's answer" do
      given(:another_user) { create(:user) }
      given!(:answer) { create(:answer, question: , user: another_user) }

      scenario 'edit answer to the question' do
        within '.answers' do
          expect(page).to_not have_link 'edit'
        end
      end
    end
  end

  describe 'Unauthenticated user' do
    scenario 'edit answer' do
      visit question_path(question)

      within '.answers' do
        expect(page).to_not have_link 'edit'
      end
    end
  end
end
