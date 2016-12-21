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

  describe('.between') do
    it('retrieves transactions in date range') do
      test_user = User.create({:name => 'Jim Padilla', :password => '1234'})
      transaction1 = Transaction.create({:category => "bill", :date => '25-12-2016', :user_id => test_user.id})
      transaction2 = Transaction.create({:category => "bill", :date => '1-11-2016', :user_id => test_user.id})
      transaction3 = Transaction.create({:category => "bill", :date => '26-12-2016', :user_id => test_user.id})
      expect(Transaction.between('2016-12-01', '2016-12-31', test_user.id)).to(eq([transaction1, transaction3]))
    end
  end
end
