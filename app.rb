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
  @budgets = Budget.all
  erb(:budgets)
end

post('/add_budget') do
  budget_name = params[:budget_name]
  budget_amount = params[:budget_amount]
  current_amount = params[:budget_amount]
  # also fetch user_id
  @budget = Budget.create({:name => budget_name, :amount => budget_amount, :current_amount => current_amount, :user_id => 5})
  redirect('/budgets')
end

get('/budget/:id') do
  # User id
  @budget = Budget.find(params[:id])
  erb(:budget)
end

get('/transactions/:id') do
  @budget = Budget.find(params[:id])
  @transactions = Transaction.all
  erb(:transactions)
end

post('/add_transaction/:id') do
  # Account ID
  @budget = Budget.find(params[:id])
  amount = params[:amount]
  date = params[:date]
  place = params[:place]
  category = params[:category]
  @transaction = Transaction.create({:account_id => 2, :amount => amount, :date => date, :place => place, :category => category, :budget_id => @budget.id})
  redirect("/transactions/#{@budget.id}")
end

get('/logout') do
  session.clear
  redirect('/')
end
