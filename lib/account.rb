class Account < ActiveRecord::Base
  belongs_to(:user)
  has_many(:transactions)
  validates(:name, :presence => true)
  validates(:balance, :presence => true)
end
