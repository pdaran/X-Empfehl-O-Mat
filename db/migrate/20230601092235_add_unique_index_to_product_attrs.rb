class AddUniqueIndexToProductAttrs < ActiveRecord::Migration[7.0]
  def change
    add_index :product_attrs, [:product_id, :attr_id], unique: true
  end
end
