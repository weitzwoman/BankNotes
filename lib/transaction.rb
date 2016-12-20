class Transaction < ActiveRecord::Base
  belongs_to(:account)
  belongs_to(:budget)
  belongs_to(:user)
  before_save(:titleize)

  private
  def titleize
    self.category = category.titleize
  end
end
