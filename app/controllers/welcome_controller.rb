class WelcomeController < ApplicationController

  def index
    @user_stocks = current_user.stocks
  end

end
