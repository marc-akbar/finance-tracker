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
        # filter average prices = -1 in chart data
        @filtered_data = @data.select{ |element| element[1] >= 0}
      else
        flash.now[:danger] = "You have entered an invalid ticker symbol"
      end
    end
    respond_to do |format|
      format.js { render partial: 'users/result' }
    end
  end

end
