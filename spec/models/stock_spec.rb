require 'rails_helper'

RSpec.describe Stock, type: :model do
  describe '.find_by_ticker' do
    it 'can lookup stocks in stock table' do
      stock = create(:stock, ticker: 'GOOG', name: 'Alphabet')

      expect(Stock.find_by_ticker('GOOG')).to eq(stock)
    end
  end

  describe '.new_from_lookup' do
    it 'can lookup stock from api' do
      stock = Stock.new_from_lookup('TSLA')

      expect(stock).to be_valid
    end
  end
end
