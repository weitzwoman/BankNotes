class Budget < ActiveRecord::Base
  has_many(:transactions)
  belongs_to(:user)

  def do_math
    self.current_amount += self.transactions[-1].amount
  end
end
