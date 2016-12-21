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
  if @user && @user.authenticate(params[:password])
    session[:user_id] = @user.id
    redirect('/user_account')
  else
    redirect('/errors')
  end
end

get('/user_account') do
  @user = User.find(session[:user_id])
  @balance = @user.accounts.sum(:balance)
  erb(:account)
end

post('/user_account') do
  @user = User.find(params['user_id'])
  new_account = @user.accounts.new({:name => params['account_name'], :balance => params['initial_balance']})
  new_account.save()
  redirect '/user_account'
end

get('/create_account') do
  erb(:user_form)
end

post('/create_account') do
  user = User.new(:name => params[:username], :password => params[:password], :password_confirmation => params[:password_again])
  if user.save
    redirect('/')
  else
    redirect('/errors')
  end
end

get('/errors') do
  erb(:errors)
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
  erb(:transactions)
end

post('/transactions') do
  @user = User.find(session[:user_id])
  amount = params[:amount].to_i
  date = params[:date]
  place = params[:place]
  category = params[:category]
  account_id = params[:account_id]
  @transaction = Transaction.create({:amount => amount, :date => date, :place => place, :category => category, :user_id => @user.id, :account_id => account_id})
  @account = Account.find(@transaction.account_id)
  @account.do_math(@transaction.amount)
  @account.save
  @budget = Budget.find(params[:budget_id].to_i)
  transaction_type = params[:transaction_type].to_i
  if transaction_type == 0
    amount *= (-1)
  end
  @budget.transactions.push(@transaction)
  @budget.do_math()
  @budget.save()
  redirect("/transactions")
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
    redirect 'errors'
  end
end



get('/user_account/:id') do
  @user = User.find(session[:user_id])
  @account = Account.find(params['id'].to_i)
  if @user.accounts.include? @account
    erb(:edit_account)
  else
    redirect 'errors'
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
