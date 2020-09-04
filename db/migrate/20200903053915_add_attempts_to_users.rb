class AddAttemptsToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :attempts, :integer
  end
end
