require 'rails_helper'

RSpec.describe 'Stocks Management', type: :feature, js: true do
  context 'as a logged-in user' do
    let(:user) { create(:user, first_name: 'Harry', last_name: 'Potter') }
    before { login_as user }

    it 'shows the news for popular stocks when not following stocks' do
      visit '/'
      expect(page).to have_text 'AMZN'
      expect(page).to have_text 'GOOG'
      expect(page).to have_text 'BRK.A'
    end

    it 'shows the news for all the stocks you are following' do
      stock = create(:stock, ticker: 'AAPL')
      create(:user_stock, user: user, stock: stock)

      visit '/'
      expect(page).to have_content 'AAPL'
    end

    it 'let you look up valid stocks' do
      visit '/my_portfolio'

      fill_in 'Enter ticker symbol', with: 'goog'
      click_on 'Search'

      expect(page).to have_content 'Alphabet, Inc.'
      expect(page).to have_content 'Go to article'
    end

    it 'raises an error when looking up an invalid ticker' do
      visit '/my_portfolio'

      fill_in 'Enter ticker symbol', with: 'poop'
      click_on 'Search'

      expect(page).to have_content 'You have entered an invalid ticker symbol'
    end

    it 'raises an error when looking up an empty field' do
      visit '/my_portfolio'

      fill_in 'Enter ticker symbol', with: ''
      click_on 'Search'

      expect(page).to have_content 'You have entered an empty search string'
    end
  end
end
