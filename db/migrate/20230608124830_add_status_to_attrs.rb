class AddStatusToAttrs < ActiveRecord::Migration[7.0]
  def change
    add_column :attrs, :status, :string
  end
end
