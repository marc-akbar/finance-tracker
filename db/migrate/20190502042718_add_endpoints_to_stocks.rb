class AddEndpointsToStocks < ActiveRecord::Migration[5.2]
  def change
    add_column :stocks, :low, :decimal
    add_column :stocks, :high, :decimal
  end
end
