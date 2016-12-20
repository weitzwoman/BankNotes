class CreateBudgetsColumnTypeOfBudget < ActiveRecord::Migration[5.0]
  def change
    add_column(:budgets, :type_of_budget, :string)
  end
end
