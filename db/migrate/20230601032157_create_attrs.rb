class CreateAttrs < ActiveRecord::Migration[7.0]
  def change
    create_table :attrs do |t|
      t.string :name
      t.string :unit
      t.string :attrtype
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
