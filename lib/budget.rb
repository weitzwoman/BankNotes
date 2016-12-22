class Budget < ActiveRecord::Base
  before_save(:titleize_budget)
  has_many(:transactions)
  belongs_to(:user)
  validates(:name, :amount, :user_id, :current_amount, :presence => true)

  def do_math
    self.current_amount += self.transactions[-1].amount
  end

  private

    def titleize_budget
      self.name = self.name.titleize
    end
end
