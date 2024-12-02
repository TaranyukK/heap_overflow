require 'rails_helper'

feature 'User can subscribe to question', "
  In order to get answer from a community
  As an authenticated user
  I'd like to be able to get email notification of new answers for my question
" do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user:) }
  given(:other_question) { create(:question) }

  scenario 'Authenticated user with subscription', :js do
    sign_in user
    visit question_path(question)

    click_on 'Unsubscribe'

    expect(page).to have_content 'Subscribe'
    expect(page).to have_no_content 'Unsubscribe'
  end

  scenario 'Authenticated user without subscription', :js do
    sign_in user
    visit question_path(other_question)

    click_on 'Subscribe'

    expect(page).to have_no_content 'Subscribe'
    expect(page).to have_content 'Unsubscribe'
  end

  scenario 'Unauthenticated user', :js do
    visit question_path(question)

    expect(page).to have_no_content 'Subscribe'
    expect(page).to have_no_content 'Unsubscribe'
  end
end
