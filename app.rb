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
