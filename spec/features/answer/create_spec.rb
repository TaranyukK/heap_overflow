require 'rails_helper'

feature 'User can write an answer to a question', "
  In order to help solve a problem
  As an authenticated user
  I'd like to be able to write an answer on the question's page
" do
  given(:user) { create(:user) }
  given(:guest) { create(:user) }
  given!(:question) { create(:question) }

  describe 'Authenticated user', :js do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'writes an answer' do
      within '.new-answer' do
        fill_in 'Body', with: 'My answer'
      end
      click_on 'Answer'

      expect(page).to have_content 'My answer'
    end

    scenario 'writes an answer with errors' do
      click_on 'Answer'

      expect(page).to have_content "Body can't be blank"
    end

    scenario 'writes an answer with attached files' do
      within '.new-answer' do
        fill_in 'Body', with: 'My answer'
        attach_file 'File', %W[#{Rails.root.join('spec/rails_helper.rb')} #{Rails.root.join('spec/spec_helper.rb')}]
      end
      click_on 'Answer'

      expect(page).to have_content 'rails_helper.rb'
      expect(page).to have_content 'spec_helper.rb'
    end

    context 'multiple sessions' do
      scenario "answer appears on another user's page", :js do
        Capybara.using_session('user') do
          sign_in(user)
          visit question_path(question)
        end

        Capybara.using_session('guest') do
          visit question_path(question)
        end

        Capybara.using_session('user') do
          within '.new-answer' do
            fill_in 'Body', with: 'My answer'
          end
          click_on 'Answer'

          expect(page).to have_content 'My answer'
        end

        Capybara.using_session('guest') do
          expect(page).to have_content 'My answer'
        end
      end
    end
  end

  describe 'Unauthenticated user' do
    scenario 'tries to write answer' do
      visit question_path(question)
      within '.new-answer' do
        fill_in 'Body', with: 'My answer'
      end
      click_on 'Answer'

      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end
end
