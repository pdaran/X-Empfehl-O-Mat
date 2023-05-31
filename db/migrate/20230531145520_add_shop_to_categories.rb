class AddShopToCategories < ActiveRecord::Migration[7.0]
  def change
    add_reference :categories, :shop, null: false, foreign_key: true
  end
end
