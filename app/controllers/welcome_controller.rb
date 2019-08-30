class WelcomeController < ApplicationController

  def index
    if current_user.stocks
      @stocks = user_stock_tickers
    else
      @stocks = popular_stocks
    end
  end

  private

  def popular_stocks
    ['AMZN', 'FB', 'MSFT', 'BABA', 'GOOG', 'CELG', 'DIS', 'NFLX', 'V']
  end

  def user_stock_tickers
    current_user.stocks.map do |stock|
      stock.ticker
    end
  end

  def create_articles(stock)
    headlines = Stock.headlines(stock)
    urls = Stock.urls(stock)
    summaries = Stock.summaries(stock)
    # top five news articles
    (0..4).map do |num|
      [headlines[num], summaries[num], urls[num]]
    end
  end
  helper_method :create_articles

end
