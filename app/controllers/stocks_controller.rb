class StocksController < ApplicationController
  def search
    if params[:stock].blank?
      flash.now[:danger] = 'You have entered an empty search string'
    else
      assign_stock
      if @stock
        assign_chart_data
        assign_news_data
        filter_chart_data
        chart_format
        create_articles
      else
        flash.now[:danger] = 'You have entered an invalid ticker symbol'
      end
    end
    respond_to do |format|
      format.js { render partial: 'users/result' }
    end
  end

  private

  def assign_stock
    @stock = Stock.new_from_lookup(params[:stock])
  end

  def assign_chart_data
    @minutes = Stock.minutes(params[:stock])
    @average_prices = Stock.average_prices(params[:stock])
  end

  def filter_chart_data
    # associate stock price with time and put in chart format
    @data = (0..@minutes.length - 1).map do |num|
      [@minutes[num], @average_prices[num]]
    end
    # filter out average prices = nil in chart data
    @filtered_data = @data.reject { |element| element[1].nil? }
    # filter price data to replace low/high in chart since API is unreliable
    @filtered_prices = @average_prices.reject(&:nil?)
  end

  def chart_format
    @decimal_data = @filtered_data.map { |element| [element[0].delete_prefix('0'), element[1].round(2)] }
  end

  def assign_news_data
    @headlines = Stock.headlines(params[:stock])
    @urls = Stock.urls(params[:stock])
    @summaries = Stock.summaries(params[:stock])
  end

  def create_articles
    @articles = (0..@headlines.length - 1).map do |num|
      [@headlines[num], @summaries[num], @urls[num]]
    end
  end
end
