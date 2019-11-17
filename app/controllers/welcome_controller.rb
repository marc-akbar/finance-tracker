class WelcomeController < ApplicationController
  def index
    @stocks = if current_user.stocks.present?
                user_stock_tickers
              else
                popular_stocks
              end
  end

  private

  def popular_stocks
    %w[AMZN FB MSFT BABA GOOG CELG DIS NFLX V MA TSLA BYND]
  end

  def user_stock_tickers
    current_user.stocks.map { |s| [s.ticker.delete('.'), s.ticker] }.to_h
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
