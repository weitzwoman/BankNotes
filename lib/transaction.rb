class Transaction < ActiveRecord::Base
  belongs_to(:account)
  belongs_to(:budget)
  belongs_to(:user)
  before_save(:titleize)

  define_singleton_method(:between) do |start_date, end_date, user_id|
     all_transactions = Transaction.where(user_id: user_id)
     transaction_in_range = []
     all_transactions.each do |transaction|
       if transaction.date >= start_date and transaction.date <= end_date
         transaction_in_range.push(transaction)
       end
     end
     transaction_in_range
   end

   private
   def titleize
     self.category = category.titleize
   end
end
