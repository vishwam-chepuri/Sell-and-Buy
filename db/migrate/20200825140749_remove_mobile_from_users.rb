class RemoveMobileFromUsers < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :mobile_number, :string
  end
end
