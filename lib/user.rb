class User < ActiveRecord::Base
  has_many(:accounts)
  has_many(:budgets)
  validates(:name, :presence => true, :uniqueness => {:case_sensitive => false})
  has_secure_password
end
