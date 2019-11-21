require 'rails_helper'

RSpec.feature 'Users', type: :feature do
  context 'as a non logged-in user' do
    it 'redirects when visiting the home page' do
      visit '/'

      expect(current_path).to eq('/users/sign_in')
      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end

    it 'allows you to sign-up' do
      visit '/users/sign_up'

      fill_in 'user_first_name', with: 'Harry'
      fill_in 'user_last_name', with: 'Potter'
      fill_in 'user_email', with: 'hogwarts@magic.com'
      fill_in 'user_password', with: 'password'
      fill_in 'user_password_confirmation', with: 'password'

      click_on 'commit'

      expect(current_path).to eq('/')
      expect(page).to have_content('Welcome! You have signed up successfully.')
    end
  end

  context 'as a logged-in user', js: true do
    let(:user) { create(:user, first_name: 'Harry', last_name: 'Potter') }
    before { login_as user }

    it 'lets you follow stocks' do
      stock = create(:stock, ticker: 'GOOG', name: 'Alphabet, Inc.')

      visit '/my_portfolio'

      fill_in 'Enter ticker symbol', with: stock.ticker
      click_on 'Search'
      click_on "Follow #{stock.name}"

      expect(page).to have_text("#{stock.name} was successfully added to your portfolio")
      expect(page).to have_content('GOOG')
    end

    it 'lets you unfollow stocks' do
      stock = create(:stock, ticker: 'GOOG', name: 'Alphabet, Inc.')
      create(:user_stock, user: user, stock: stock)

      visit '/my_portfolio'
      click_on 'Remove'

      page.driver.browser.switch_to.alert.accept

      expect(page).to have_text("#{stock.name} was successfully removed from your portfolio")
    end

    it 'lets you look up other users' do
      create(:user, first_name: 'Albus', last_name: 'Dumbledore')

      visit '/my_friends'

      fill_in 'Enter name or email', with: 'albus'
      click_on 'Search'

      expect(page).to have_content 'Albus'
    end

    it 'lets you see stocks other users are following' do
      user2 = create(:user, first_name: 'Albus', last_name: 'Dumbledore')
      stock = create(:stock, ticker: 'TSLA', name: 'Tesla, Inc.')
      create(:user_stock, user: user2, stock: stock)

      visit '/my_friends'

      fill_in 'Enter name or email', with: 'albus'
      click_on 'Search'
      click_on 'View Portfolio'

      expect(current_path).to eq('/users/2')
      expect(page).to have_content('Albus')
      expect(page).to have_content('TSLA')
    end
  end
end
