class CreateRecommendation < ActiveRecord::Migration[7.0]
  def change
    create_table :recommendations do |t|
      t.references :customer, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.timestamps
    end
  end
end