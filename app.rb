require("bundler/setup")
Bundler.require(:default)
require('pry')

Dir[File.dirname(__FILE__) + '/lib/*.rb'].each { |file| require file }

get('/') do
  erb(:index)
end

post('/signin') do
  @user = User.find_by(name: params['username'])
  redirect('/user_account')
end

get('/user_account') do
  @user = User.find_by(name: params['username'])
  erb(:account)
end

get('/create_account') do
  erb(:user_form)
end

post('/create_account') do
  User.create(name: params['username'])
  redirect('/')
end
