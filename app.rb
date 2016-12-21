require("bundler/setup")
Bundler.require(:default)
require('pry')
enable :sessions

Dir[File.dirname(__FILE__) + '/lib/*.rb'].each { |file| require file }

get('/') do
  erb(:index)
end

post('/signin') do
  @user = User.find_by(name: params['username'])
  if @user && @user.password_verified(params[:password])
    session[:user_id] = @user.id
    redirect('/user_account')
  else
    @new_user = @user
    erb(:errors)
  end
end

get('/user_account') do
  @user = User.find(session[:user_id])
  @balance = @user.accounts.sum(:balance)
  @accounts = @user.accounts
  @account_assets = Account.where("balance > 0 AND user_id = ?", @user.id)
  @account_liabilities= Account.where("balance < 0 AND user_id = ?", @user.id)
  erb(:account)
end

post('/user_account') do
  @user = User.find(params['user_id'])
  balance = params['initial_balance'].to_i
  account_type = params[:account_type].to_i
  if account_type == 0
    balance *= (-1)
  end
  new_account = @user.accounts.new({:name => params['account_name'], :balance => balance})
  new_account.save()
  redirect '/user_account'
end

get('/create_account') do
  erb(:user_form)
end

post('/create_account') do
  @new_user = User.new(:name => params[:username], :password => params[:password], :password_confirmation => params[:password_again])
  if @new_user.save
    redirect('/')
  else
    @new_user = @new_user
    erb(:errors)
  end
end


delete('/user_account') do
  account = Account.find(params['account_id'].to_i)
  account.destroy()
  redirect 'user_account'
end

patch('/user_account') do
  account = Account.find(params['account_id'].to_i)
  account.update()
  redirect 'user_account'
end

get('/budgets') do
  @user = User.find(session[:user_id])
  @budgets = @user.budgets
  @budgets_monthly = Budget.where("type_of_budget = ? AND user_id = ?", "monthly", @user.id)
  @budgets_yearly = Budget.where("type_of_budget = ? AND user_id = ?", "yearly", @user.id)
  erb(:budgets)
end

post('/add_budget') do
  @user = User.find(session[:user_id])
  budget_name = params[:budget_name]
  budget_amount = params[:budget_amount].to_i
  current_amount = params[:budget_amount].to_i
  type_of_budget = params[:type_of_budget]
  @budget = Budget.create({:name => budget_name, :amount => budget_amount, :current_amount => current_amount, :user_id => @user.id, :type_of_budget => type_of_budget})
  redirect("/budgets")
end

get('/budget/:id') do
  @budget = Budget.find(params[:id])
  @user = User.find(session[:user_id])
  if @user.budgets.include? @budget
    erb(:budget)
  else
    erb(:errors)
  end
end

get('/transactions') do
  @user = User.find(session[:user_id])
  @budgets = @user.budgets
  @transactions = @user.transactions
  @transactions_income = Transaction.where("amount > 0 AND user_id = ?", @user.id)
  @transactions_spending = Transaction.where("amount < 0 AND user_id = ?", @user.id)
  erb(:transactions)
end

post('/transactions') do
  @user = User.find(session[:user_id])
  amount = params[:amount]
  date = params[:date]
  place = params[:place]
  category = params[:category]
  account_id = params[:account_id]
  if amount == ''
    erb(:errors)
  else
    amount = amount.to_i
    transaction_type = params[:transaction_type].to_i
    if transaction_type == 0
      amount *= (-1)
    end
    @transaction = Transaction.create({:amount => amount, :date => date, :place => place, :category => category, :user_id => @user.id, :account_id => account_id})
    @account = Account.find(@transaction.account_id)
    @account.do_math(@transaction.amount)
    @account.save
    @budget = Budget.find(params[:budget_id].to_i)
    @budget.transactions.push(@transaction)
    @budget.do_math()
    @budget.save()
    redirect("/transactions")
  end
end

delete('/transactions') do
  transaction = Transaction.find(params['transaction_id'].to_i)
  transaction.destroy()
  redirect '/transactions'
end

get('/transactions/:category') do
  @user = User.find(session[:user_id])
  @category = params["category"]
  @transaction_category = []
  @user.transactions.each do |transaction|
    if transaction.category == @category
      @transaction_category.push(transaction)
    end
  end
  @transaction_category
  erb(:transaction_category)
end

get('/transactions_edit/:id') do
  @user = User.find(session[:user_id])
  @transaction = Transaction.find(params['id'].to_i)
  if @user.transactions.include? @transaction
    erb(:edit_transaction)
  else
    erb(:errors)
  end
end

get('/user_account/:id') do
  @user = User.find(session[:user_id])
  @account = Account.find(params['id'].to_i)
  if @user.accounts.include? @account
    erb(:edit_account)
  else
    erb(:errors)
  end
end

patch('/user_account/:id') do
  @user = User.find(session[:user_id])
  @account = Account.find(params['id'].to_i)
  @account.update(name: params['name'])
  redirect '/user_account'
end

get('/logout') do
  session.clear
  redirect('/')
end

get('/edit_profile') do
  @user = User.find(session[:user_id])
  erb(:edit_profile)
end

patch('/edit_profile') do
  @user = User.find(session[:user_id])
  @user.update(name: params['name'])
  redirect '/edit_profile'
end

delete('/edit_profile') do
  @user = User.find(session[:user_id])
  @user.destroy()
  redirect '/'
end

patch('/transactions_edit/:id') do
  @user = User.find(session[:user_id])
  @transaction = Transaction.find(params['id'].to_i)
  category = params['category']
  amount = params['amount']
  date = params['date']
  place = params['place']
  budget_id = params['budget_id']
  account_id = params['account_id']
  if category == ''
    category = @transaction.category
  end
  if amount == ''
    amount = @transaction.amount
  end
  if date == ''
    date = @transaction.date
  end
  if place == ''
    place = @transaction.place
  end
  if budget_id == ''
    budget_id = @transaction.budget_id
  end
  if account_id == ''
    account_id = @transaction.account_id
  end
  @transaction.update({:category => category, :amount => amount, :date => date, :place => place, :budget_id => budget_id, :account_id => account_id})
  redirect '/transactions'
end

patch('/update_budget/:id') do
  budget_name = params[:budget_name]
  budget_amount = params[:budget_amount].to_i
  type_of_budget = params[:type_of_budget]
  @budget = Budget.find(params[:id])
  @budget.update({:name => budget_name, :amount => budget_amount, :current_amount => budget_amount, :type_of_budget => type_of_budget})
  redirect '/budgets'
end

delete('/user_budget') do
  budget = Budget.find(params['budget_id'].to_i)
  budget.destroy()
  redirect '/budgets'
end

post('/transaction_search') do
  start_date = params[:start_date]
  end_date = params[:end_date]
  @user = User.find(session[:user_id])
  @transactions = Transaction.between(start_date, end_date, @user.id)
  erb(:transactions)
end

get('/sort_by_category') do
  @user = User.find(session[:user_id])
  @budgets = @user.budgets
  @transactions = @user.transactions.order('category asc')
  erb(:transactions)
end

get('/sort_by_place') do
  @user = User.find(session[:user_id])
  @budgets = @user.budgets
  @transactions = @user.transactions.order('place asc')
  erb(:transactions)
end

get('/sort_by_date') do
  @user = User.find(session[:user_id])
  @budgets = @user.budgets
  @transactions = @user.transactions.order('date asc')
  erb(:transactions)
end

get('/sort_by_amount') do
  @user = User.find(session[:user_id])
  @budgets = @user.budgets
  @transactions = @user.transactions.order('amount desc')
  erb(:transactions)
end

get('/sort_by_account') do
  @user = User.find(session[:user_id])
  @balance = @user.accounts.sum(:balance)
  @accounts = @user.accounts.order('name asc')
  erb(:account)
end

get('/sort_by_balance') do
  @user = User.find(session[:user_id])
  @balance = @user.accounts.sum(:balance)
  @accounts = @user.accounts.order('balance desc')
  erb(:account)
end

get('/stocks') do
  @user = User.find(session[:user_id])
  erb(:stocks)
end

post('/stocks') do
  @user = User.find(session[:user_id])
  @stock = StockQuote::Stock.quote(params['symbol'])
  erb(:stocks)
end
