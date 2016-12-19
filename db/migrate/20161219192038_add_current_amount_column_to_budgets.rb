class AddCurrentAmountColumnToBudgets < ActiveRecord::Migration[5.0]
  def change
    add_column(:budgets, :current_amount, :decimal)
  end
end
