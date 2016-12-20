require 'spec_helper'

describe Account do
  it { should belong_to(:user)}
  it { should have_many(:transactions)}
  it { should validate_presence_of(:name)}
  it { should validate_presence_of(:balance)}


  describe('#do_math') do
    it('will do math on the account balance') do
      user = User.new({:name => "Tracie", :password => "1234"})
      user.save
      account = user.accounts.create({:name => "Checking", :balance => 500})
      transaction = Transaction.create({:amount => 100, :date => nil, :place => nil, :category => "nil", :user_id => user.id, :account_id => account.id})
      account.do_math(transaction.amount)
      expect(account.balance()).to(eq(600))
    end
  end
end
