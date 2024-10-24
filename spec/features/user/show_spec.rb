require 'rails_helper'

feature 'User can see his profile', "
  In order to see my profile
  As an authenticated user
  I'd like to be able to see my profile
" do
  given!(:user) { create(:user) }

  background { sign_in(user) }

  scenario 'User visit his profile' do
    click_on 'Profile'

    expect(page).to have_content user.email
  end
end
