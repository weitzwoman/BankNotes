class Budget < ActiveRecord::Base
  has_many(:transactions)
  belongs_to(:user)
  validates(:name, :amount, :user_id, :current_amount, :presence => true)

  def do_math
    self.current_amount += self.transactions[-1].amount
  end
end
