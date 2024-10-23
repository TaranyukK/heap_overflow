require 'rails_helper'

feature 'User can add award to question', %q{
  In order to award author of best answer in my question
  As an question's author
  I'd like to be able to add award
} do
  given(:user) { create(:user) }

  background do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'
    fill_in 'Award title', with: 'test award'
  end

  scenario 'User adds award when asks question' do
    attach_file 'Image', "#{Rails.root}/spec/fixtures/1x1.png"

    click_on 'Ask'

    expect(page).to have_content 'test award'
  end

  scenario 'User adds award without image when asks question' do
    click_on 'Ask'

    expect(page).to have_content 'Award image must be attached'
  end
end