class WelcomeController < ApplicationController
  def index
    @stocks = if current_user.stocks.present?
                parse_tickers_with_dots(user_stock_tickers)
              else
                parse_tickers_with_dots(popular_stocks)
              end
  end

  private

  def popular_stocks
    %w[AMZN FB MSFT BABA GOOG CELG DIS NFLX V MA TSLA BYND BRK.A]
  end

  def user_stock_tickers
    current_user.stocks.map(&:ticker)
  end

  def parse_tickers_with_dots(stocks)
    stocks.map { |ticker| [ticker.delete('.'), ticker] }.to_h
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
