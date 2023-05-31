class CreateShops < ActiveRecord::Migration[7.0]
  def change
    create_table :shops do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.text :address
      t.string :phone_no
      t.string :status

      t.timestamps
    end
  end
end
