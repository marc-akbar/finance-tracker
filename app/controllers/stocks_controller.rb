class StocksController < ApplicationController
  def search
    if params[:stock].present?
      @stock = Stock.new_from_lookup(params[:stock])
      @minutes = Stock.minutes(params[:stock])
      @average_prices = Stock.average_prices(params[:stock])

      # associate stock price with time
      @data = (0..@minutes.length-1).map do |num|
        [@minutes[num], @average_prices[num]]
      end

      # filter data
      @filtered_data = @data.select{ |element| element[1] >= 0}

      if @stock
        respond_to do |format|
          # only renders the partial
          format.js { render partial: 'users/result' }
        end
      else
        flash[:danger] = "You have entered an invalid ticker symbol"
        redirect_to my_portfolio_path
      end
    else
      flash[:danger] = "You have entered an empty search string"
      redirect_to my_portfolio_path
    end
  end
end
