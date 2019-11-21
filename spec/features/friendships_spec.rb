require 'rails_helper'

RSpec.feature 'Friendships', type: :feature do
  context 'as a logged-in user', js: true do
    let(:user) { create(:user, first_name: 'Harry', last_name: 'Potter') }
    before { login_as user }

    it 'lets you follow other users' do
      friend = create(:user, first_name: 'Albus', last_name: 'Dumbledore')

      visit '/my_friends'

      fill_in 'Enter name or email', with: 'albus'
      click_on 'Search'
      click_on 'Follow'

      expect(current_path).to eq('/my_friends')
      expect(page).to have_content('You are now following Albus')
    end

    it 'lets you unfollow other users' do
      friend = create(:user, first_name: 'Albus', last_name: 'Dumbledore')
      create(:friendship, user: user, friend: friend)

      visit '/my_friends'
      click_on 'Unfollow'

      page.driver.browser.switch_to.alert.accept

      expect(current_path).to eq('/my_friends')
      expect(page).to have_content('You are no longer following this person')
    end
  end
end
