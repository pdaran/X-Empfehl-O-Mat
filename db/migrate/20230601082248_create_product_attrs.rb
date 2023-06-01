class CreateProductAttrs < ActiveRecord::Migration[7.0]
  def change
    create_table :product_attrs do |t|
      t.string :value
      t.references :product, null: false, foreign_key: true
      t.references :attr, null: false, foreign_key: true

      t.timestamps
    end
  end
end
