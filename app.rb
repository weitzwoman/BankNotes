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
  @budgets = Budget.all
  erb(:budgets)
end

post('/add_budget') do
  @user = User.find(session[:user_id])
  budget_name = params[:budget_name]
  budget_amount = params[:budget_amount]
  current_amount = params[:budget_amount]
  @budget = Budget.create({:name => budget_name, :amount => budget_amount, :current_amount => current_amount, :user_id => @user.id })
  redirect("/budgets")
end

get('/budget/:id') do
  @budget = Budget.find(params[:id])
  erb(:budget)
end

get('/transactions') do
  @user = User.find(session[:user_id])
  @budgets = @user.budgets
  @transactions = @user.transactions
  erb(:transactions)
end

post('/transactions') do
  # Account ID
  @user = User.find(session[:user_id])
  # @budget = Budget.find(params[:id])
  amount = params[:amount]
  date = params[:date]
  place = params[:place]
  category = params[:category]
  account_id = params[:account_id]
  @transaction = Transaction.create({:amount => amount, :date => date, :place => place, :category => category, :user_id => @user.id, :account_id => account_id})
  @account = Account.find(@transaction.account_id)
  @account.balance += @transaction.amount
  redirect("/transactions")
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
