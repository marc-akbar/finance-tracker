class RemoveImageFromStocks < ActiveRecord::Migration[5.2]
  def change
    add_column :stocks, :summary, :string
  end
end
