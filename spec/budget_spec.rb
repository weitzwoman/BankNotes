require 'spec_helper'

describe(Budget) do
  it('adds a transaction to a budget') do
    test_user = User.create({:name => 'Jim Padilla'})
    test_budget = Budget.create({:name => 'Gas', :amount => 100.00, :current_amount => 100.00, :user_id => test_user.id})
    test_transaction = Transaction.create({:amount => -20, :date => '12-19-2016 03:30:00', :place => 'Portland', :category => 'entertainment', :budget_id => test_budget.id})
    expect(test_budget.transactions()).to(eq([test_transaction]))
  end

  describe('#do_math') do
    it('add transactions') do
      test_user = User.create({:name => 'Jim Padilla'})
      test_budget = Budget.create({:name => 'Gas', :amount => 100.00, :current_amount => 100.00, :user_id => test_user.id})
      test_transaction = Transaction.create({:amount => -20, :date => '12-19-2016 03:30:00', :place => 'Portland', :category => 'entertainment', :budget_id => test_budget.id})
      test_budget.transactions.push(test_transaction)
      test_budget.do_math()
      test_budget.save
      expect(test_budget.current_amount).to(eq(80))
    end
  end

  it {should validate_presence_of(:name)}
  it {should validate_presence_of(:amount)}
  it {should validate_presence_of(:current_amount)}
  it {should have_many(:transactions)}

end
