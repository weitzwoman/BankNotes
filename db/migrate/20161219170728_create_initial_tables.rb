class CreateInitialTables < ActiveRecord::Migration[5.0]
  def change
    create_table(:users) do |u|
      u.column(:name, :string)
      u.column(:password_digest, :string)

      u.timestamps
    end
    create_table(:accounts) do |a|
      a.column(:name, :string)
      a.column(:user_id, :integer)
      a.column(:balance, :decimal)

      a.timestamps
    end
    create_table(:transactions) do |t|
      t.column(:account_id, :integer)
      t.column(:amount, :decimal)
      t.column(:date, :datetime)
      t.column(:place, :string)
      t.column(:category, :string)
      t.column(:budget_id, :integer)

      t.timestamps
    end
    create_table(:budget) do |b|
      b.column(:name, :string)
      b.column(:amount, :decimal)
      b.column(:user_id, :integer)

      b.timestamps
    end
  end
end
