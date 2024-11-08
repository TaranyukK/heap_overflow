require 'rails_helper'

feature 'User can add links to answer', "
  In order to provide additional info to my answer
  As an answer's author
  I'd like to be able to add links
" do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given(:url) { 'https://google.com' }
  given(:gist_url) { 'https://gist.github.com/TaranyukK/8502ae3e21f1fd387002c9050e436867' }

  background do
    sign_in(user)
    visit question_path(question)

    within '.new-answer' do
      fill_in 'Body', with: 'My answer'
      fill_in 'Link name', with: 'Link'
    end
  end

  scenario 'User adds link when give an answer', :js do
    fill_in 'Url', with: url

    click_on 'Answer'

    within '.answers' do
      expect(page).to have_link 'Link', href: url
    end
  end

  scenario 'User adds gist link when give an answer', :js do
    fill_in 'Url', with: gist_url

    click_on 'Answer'

    within '.answers' do
      expect(page).to have_content 'This is the test!'
    end
  end
end
