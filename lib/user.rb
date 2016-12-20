class User < ActiveRecord::Base
  has_many(:accounts)
  has_many(:budgets)
  has_many(:transactions)
  validates(:name, :presence => true, :uniqueness => {:case_sensitive => false})
  has_secure_password

  validates :password, presence: { on: :create }
end
