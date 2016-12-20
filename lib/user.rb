class User < ActiveRecord::Base
  has_many(:accounts)
  has_many(:budgets)
  has_many(:transactions)
  validates(:name, :presence => true, :uniqueness => {:case_sensitive => false})
  has_secure_password

  validates :password, presence: { on: :create }

  define_method(:password_verified) do |password|
    verified = authenticate(password)
    errors.add(:password, 'Username or password is invalid. Please resubmit.') unless verified
    verified
  end
end
