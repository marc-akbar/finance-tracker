class Stock < ApplicationRecord
  def self.new_from_lookup(ticker_symbol)
    begin
      looked_up_stock = StockQuote::Stock.quote(ticker_symbol)
      # creates new stock object with following parameters (same as Stock.new/self.new)
      new(name: looked_up_stock.company_name, ticker: looked_up_stock.symbol, last_price: looked_up_stock.latest_price,
          low: looked_up_stock.low, high: looked_up_stock.high)
    rescue Exception => e
      return nil
    end
  end

  def self.minutes(ticker_symbol)
    StockQuote::Stock.chart(ticker_symbol, '1d').chart.map do |day|
      day['minute']
    end
  end

  def self.average_prices(ticker_symbol)
    StockQuote::Stock.chart(ticker_symbol, '1d').chart.map do |day|
      day['average']
    end
  end
end
