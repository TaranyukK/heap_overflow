require 'rails_helper'

feature 'User can add links to question', "
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
" do
  given(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/wojteklu/73c6914cc446146b8b533c0988cf8d29' }

  scenario 'User adds link when asks question' do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'
    fill_in 'Link name', with: 'Gist'
    fill_in 'Url', with: gist_url

    click_on 'Ask'

    expect(page).to have_link 'Gist', href: gist_url
  end
end
