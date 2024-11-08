require 'rails_helper'

feature 'User can create a comment', "
  In order to comment answer/question
  As an authenticated user
  I want to be able to comment answer/question
" do
  given(:user) { create(:user) }
  given(:guest) { create(:user) }
  given(:question) { create(:question, user:) }
  given!(:answer) { create(:answer, user:, question:) }

  describe 'Question' do
    describe 'Authenticated user', :js do
      background do
        sign_in(user)
        visit question_path(question)
      end

      scenario 'comments the question' do
        within '.question .new-comment' do
          fill_in 'Body', with: 'My comment'
          click_on 'Comment'
        end

        within '.question-comments' do
          expect(page).to have_content 'My comment'
        end
      end

      scenario 'comments the question with errors' do
        within '.question .new-comment' do
          click_on 'Comment'
        end

        within '.question .new-comment-errors' do
          expect(page).to have_content "Body can't be blank"
        end
      end

      context 'multiple sessions' do
        scenario "comment appears on another user's page", :js do
          Capybara.using_session('user') do
            sign_in(user)
            visit question_path(question)
          end

          Capybara.using_session('guest') do
            visit question_path(question)
          end

          Capybara.using_session('user') do
            within '.question .new-comment' do
              fill_in 'Body', with: 'My comment'
              click_on 'Comment'
            end

            within '.question-comments' do
              expect(page).to have_content 'My comment'
            end
          end

          Capybara.using_session('guest') do
            within '.question-comments' do
              expect(page).to have_content 'My comment'
            end
          end
        end
      end
    end

    scenario 'Unauthenticated user tries to comment the question' do
      visit question_path(question)

      within '.question .new-comment' do
        click_on 'Comment'
      end
      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end

  describe 'Answer' do
    describe 'Authenticated user', :js do
      background do
        sign_in(user)
        visit question_path(question)
      end

      scenario 'comments the answer' do
        within "#answer-id-#{answer.id} .new-comment" do
          fill_in 'Body', with: 'My comment'
          click_on 'Comment'
        end

        within "#answer-id-#{answer.id} .answer-comments" do
          expect(page).to have_content 'My comment'
        end
      end

      scenario 'comments the answer with errors' do
        within "#answer-id-#{answer.id} .new-comment" do
          click_on 'Comment'
        end

        within "#answer-id-#{answer.id} .new-comment-errors" do
          expect(page).to have_content "Body can't be blank"
        end
      end

      context 'multiple sessions' do
        scenario "comment appears on another user's page", :js do
          Capybara.using_session('user') do
            sign_in(user)
            visit question_path(question)
          end

          Capybara.using_session('guest') do
            visit question_path(question)
          end

          Capybara.using_session('user') do
            within "#answer-id-#{answer.id} .new-comment" do
              fill_in 'Body', with: 'My comment'
              click_on 'Comment'
            end

            within "#answer-id-#{answer.id} .answer-comments" do
              expect(page).to have_content 'My comment'
            end
          end

          Capybara.using_session('guest') do
            within "#answer-id-#{answer.id} .answer-comments" do
              expect(page).to have_content 'My comment'
            end
          end
        end
      end
    end

    scenario 'Unauthenticated user tries to comment the answer' do
      visit question_path(question)
      within "#answer-id-#{answer.id} .new-comment" do
        click_on 'Comment'
      end
      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end
end
