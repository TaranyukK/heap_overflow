require 'rails_helper'

feature 'User can see his profile', %q{
  In order to see my profile
  As an authenticated user
  I'd like to be able to see my profile
} do
  given!(:user) { create(:user) }

  background { sign_in(user) }

  scenario 'User visit his profile' do
    click_on 'Profile'

    expect(page).to have_content user.email
  end
end

feature 'User can see his awards', %q{
  In order to see my awards
  As an authenticated user
  I'd like to be able to see my awards
} do
  given(:question) { create(:question, :with_award) }
  given(:award) { question.award }
  given!(:user) { create(:user, awards: [award]) }

  background { sign_in(user) }

  scenario 'User see his awards' do
    click_on 'Profile'

    expect(page).to have_content award.title
  end
end
