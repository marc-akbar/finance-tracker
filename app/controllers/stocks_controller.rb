class StocksController < ApplicationController

  def search
    if params[:stock].blank?
      flash.now[:danger] = "You have entered an empty search string"
    else
      @stock = Stock.new_from_lookup(params[:stock])
      if @stock
        @minutes = Stock.minutes(params[:stock])
        @average_prices = Stock.average_prices(params[:stock])
        # associate stock price with time and put in chart format
        @data = (0..@minutes.length-1).map do |num|
          [@minutes[num], @average_prices[num]]
        end
        # filter out average prices = nil in chart data
        @filtered_data = @data.select{ |element| element[1] != nil}
        # convert ot monotary/time format
        @decimal_data = @filtered_data.map{ |element| [element[0].delete_prefix("0"), element[1].round(2)] }
        @articles = Stock.articles(params[:stock])
      else
        flash.now[:danger] = "You have entered an invalid ticker symbol"
      end
    end
    respond_to do |format|
      format.js { render partial: 'users/result' }
    end
  end

end
