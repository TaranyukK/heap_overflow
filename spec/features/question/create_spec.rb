require 'rails_helper'

feature 'User can create question', "
  In order to get answer from community
  As an unauthenticated user
  I'd like to be able to create questions
" do
  given(:user) { create(:user) }
  given(:guest) { create(:user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit questions_path
      click_on 'Ask question'
    end

    scenario 'asks a question' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
      click_on 'Ask'

      expect(page).to have_content 'Your question successfully created.'
      expect(page).to have_content 'Test question'
      expect(page).to have_content 'text text text'
    end

    scenario 'asks a question with errors' do
      click_on 'Ask'

      expect(page).to have_content "Title can't be blank"
    end

    scenario 'asks a question with attached files' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
      attach_file 'File', %W[#{Rails.root.join('spec/rails_helper.rb')} #{Rails.root.join('spec/spec_helper.rb')}]
      click_on 'Ask'
      click_on 'Test question'

      expect(page).to have_content 'rails_helper.rb'
      expect(page).to have_content 'spec_helper.rb'
    end

    context 'multiple sessions' do
      scenario "question appears on another user's page", :js do
        Capybara.using_session('user') do
          sign_in(user)
          visit questions_path
        end

        Capybara.using_session('guest') do
          visit questions_path
        end

        Capybara.using_session('user') do
          click_on 'Ask question'

          fill_in 'Title', with: 'Test question'
          fill_in 'Body', with: 'text text text'

          click_on 'Ask'
          expect(page).to have_content 'Your question successfully created.'
          expect(page).to have_content 'Test question'
          expect(page).to have_content 'text text text'
        end

        Capybara.using_session('guest') do
          expect(page).to have_content 'Test question'
        end
      end
    end
  end

  describe 'Unauthenticated user' do
    scenario 'tries to ask a question' do
      visit root_path

      expect(page).not_to have_button 'Ask question'
    end
  end
end
