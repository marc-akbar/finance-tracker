class AddNewsToStocks < ActiveRecord::Migration[5.2]
  def change
    add_column :stocks, :headline, :string
    add_column :stocks, :url, :string
    add_column :stocks, :image, :string
  end
end
