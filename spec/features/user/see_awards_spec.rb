require 'rails_helper'

feature 'User can see his awards', "
  In order to see my awards
  As an authenticated user
  I'd like to be able to see my awards
" do
  given(:question) { create(:question, :with_award) }
  given(:award) { question.award }
  given!(:user) { create(:user, awards: [award]) }

  background { sign_in(user) }

  scenario 'User see his awards' do
    click_on 'Profile'

    expect(page).to have_content award.title
  end
end
