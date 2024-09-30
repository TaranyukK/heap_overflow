require 'rails_helper'

feature 'Author of question can select the best answer', %q{
  In order to highlight the best answer
  As the author of the question
  I'd like to be able to select the best answer
} do
  given!(:question) { create(:question) }

  describe 'Authenticated user', js: true do
    given(:user) { create(:user) }
    given!(:answer) { create(:answer, question:, user:) }
    given!(:another_answer) { create(:answer, question:, user:) }

    background do
      sign_in(user)
      visit question_path(question)
    end

    context 'as the author of the question' do
      scenario 'selects an answer as the best' do
        within "#answer-id-#{answer.id}" do
          click_on 'mark as best'

          expect(page).to have_content 'Best'
        end
      end

      scenario 'changes the best answer' do
        within "#answer-id-#{answer.id}" do
          click_on 'mark as best'
          expect(page).to have_content 'Best'
        end

        within "#answer-id-#{another_answer.id}" do
          click_on 'mark as best'
          expect(page).to have_content 'Best'
        end

        within "#answer-id-#{answer.id}" do
          expect(page).to_not have_content 'Best'
        end
      end
    end

    context 'as not the author of the question' do
      given(:another_user) { create(:user) }
      given(:another_question) { create(:question, user: another_user) }
      given(:another_answer) { create(:answer, :best, question: another_question, user: another_user) }

      scenario 'tries to select the best answer' do
        visit question_path(another_question)

        within '.answers' do
          expect(page).to_not have_link 'mark as best'
        end
      end
    end
  end

  describe 'Unauthenticated user' do
    scenario 'mark the best answer' do
      visit question_path(question)

      within '.answers' do
        expect(page).to_not have_link 'mark as best'
      end
    end
  end
end
