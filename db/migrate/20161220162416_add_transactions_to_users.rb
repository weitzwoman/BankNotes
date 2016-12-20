class AddTransactionsToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column(:transactions, :user_id, :integer)
  end
end
