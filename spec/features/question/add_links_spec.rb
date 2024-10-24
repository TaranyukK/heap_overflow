require 'rails_helper'

feature 'User can add links to question', "
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
" do
  given(:user) { create(:user) }
  given(:url) { 'https://google.com' }
  given(:gist_url) { 'https://gist.github.com/TaranyukK/8502ae3e21f1fd387002c9050e436867' }

  background do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'
    fill_in 'Link name', with: 'Link'
  end

  scenario 'User adds link when asks question' do
    fill_in 'Url', with: url

    click_on 'Ask'

    expect(page).to have_link 'Link', href: url
  end

  scenario 'User adds gist link when asks question' do
    fill_in 'Url', with: gist_url

    click_on 'Ask'

    expect(page).to have_content 'This is the test!'
  end
end
