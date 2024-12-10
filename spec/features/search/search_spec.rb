require 'rails_helper'

feature 'User can use the search bar', "
  In order to find a question/answer/comment
  As an user
  I want to use the search bar
" do
  given!(:user) { create(:user, email: 'my@example.com') }
  given!(:question) { create(:question, user:) }
  given!(:answer) { create(:answer, question:, user:) }
  given!(:comment) { create(:comment, commentable: question, user:) }

  background { visit root_path }

  scenario 'searches for "My"' do
    fill_in 'query', with: 'My'
    click_on 'Search'

    expect(page).to have_content 'My Question Title'
    expect(page).to have_content 'My Answer Body'
    expect(page).to have_content 'My Comment Body'
    expect(page).to have_content 'my@example.com'
  end

  scenario 'searches question for "My"' do
    fill_in 'query', with: 'My'
    select 'Question', from: 'model'
    click_on 'Search'

    expect(page).to have_content 'My Question Title'
    expect(page).to have_no_content 'My Answer Body'
    expect(page).to have_no_content 'My Comment Body'
    expect(page).to have_no_content 'my@example.com'
  end
end
