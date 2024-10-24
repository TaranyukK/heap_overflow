require 'rails_helper'

feature 'Any user can see questions', "
  In order to get answer from community
  As an any user
  I'd like to be able to see questions
" do
  given!(:questions) { create_list(:question, 3) }

  scenario 'see questions' do
    visit questions_path

    questions.each do |question|
      expect(page).to have_content(question.title)
      expect(page).to have_content(question.body)
    end
  end
end
