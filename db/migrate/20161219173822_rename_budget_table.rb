class RenameBudgetTable < ActiveRecord::Migration[5.0]
  def change
    rename_table :budget, :budgets
  end
end
