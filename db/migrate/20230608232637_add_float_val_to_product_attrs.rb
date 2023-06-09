class AddFloatValToProductAttrs < ActiveRecord::Migration[7.0]
  def change
    add_column :product_attrs, :float_val, :float
  end
end
