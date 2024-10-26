require 'rails_helper'

feature 'User can sign up', "
  In order to ask questions and give answers
  As an unauthenticated user
  I'd like to be able to sign up
" do
  background do
    visit new_user_registration_path
  end

  scenario 'User signs up with valid data' do
    fill_in 'Email', with: 'test@test.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
    expect(page).to have_content 'Log out'
  end

  scenario 'User signs up with invalid data' do
    click_on 'Sign up'

    expect(page).to have_content "Email can't be blank"
    expect(page).to have_content "Password can't be blank"
  end
end
