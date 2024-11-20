require 'rails_helper'

feature 'OAuth Authentication', type: :feature do
  OmniAuth.config.test_mode = true

  context 'GitHub authentication' do
    scenario 'user can sign in with GitHub' do
      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({
                                                                    provider: 'github',
                                                                    uid:      '12345',
                                                                    info:     { email: 'github_user@example.com' }
                                                                  })
      visit new_user_session_path
      click_on 'Sign in with GitHub'

      expect(page).to have_content 'Successfully authenticated from GitHub account.'
    end
  end

  context 'Facebook authentication' do
    scenario 'user can sign in with Facebook' do
      OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
                                                                      provider: 'facebook',
                                                                      uid:      '67890',
                                                                      info:     { email: 'facebook_user@example.com' }
                                                                    })
      visit new_user_session_path
      click_on 'Sign in with Facebook'

      expect(page).to have_content 'Successfully authenticated from Facebook account.'
    end
  end
end
