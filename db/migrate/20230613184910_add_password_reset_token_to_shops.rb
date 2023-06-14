class AddPasswordResetTokenToShops < ActiveRecord::Migration[7.0]
  def change
    add_column :shops, :password_reset_token, :string
    add_index :shops, :password_reset_token, unique: true
    add_column :shops, :password_reset_sent_at, :datetime
  end
end
