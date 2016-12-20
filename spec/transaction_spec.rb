require 'spec_helper'

describe(Transaction) do
  it { should belong_to(:account)}
  it { should belong_to(:user)}
  it { should belong_to(:budget)}

  describe("#titleize") do
    it('capitalizes all words in a category name') do
      test_transaction = Transaction.create({:category => "groceries", :amount => -20, :date => '12-19-2016 03:30:00', :place => 'Portland'})
      expect(test_transaction.category()).to(eq("Groceries"))
    end
  end
end

# "account_id"
# "budget_id"
# "user_id"
