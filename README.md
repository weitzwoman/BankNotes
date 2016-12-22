# _BankNotes_

#### _A web application to track spending, create budgets, get stock quotes, and track income and accounts. Team Week Project for Epicodus Ruby Course 12/22/2016_

#### By _**Tracie Weitzman, Jonathan Thom, Jim Padilla, and Cody Brubaker**_

## Specifications

#### 1. Creates unique User Profiles with encrypted passwords.

#### 2. Users can add Accounts (assets and liabilities) and view Account balances in tables and charts, sort by names and amounts, and edit Accounts.

#### 3. Users can add Budgets (monthly and yearly) and view Budget balances in tables and charts, and edit Budgets.

#### 4. Users can add Transactions which will change the balances of Accounts and Budgets associated with. Users can view Transactions in tables and charts, edit Transactions, and search by date. Transactions can by sorted by name, place, date or amount.

#### 5. Users can view Stock Quotes by stock symbol.

## Setup/Installation Requirements

* _In the command line, run:_
```
postgres
```
* _Then, in another window:_
```
git clone https://github.com/JonathanWThom/Personal-Finance
cd Personal-Finance
bundle
rake db:create
bundle exec rake db:migrate
rake db:test:prepare
ruby app.rb
```
* _Then, in any modern browser, navigate to:_
```
localhost:4567
```
* _or view on [Heroku](http://banknotes-epicodus.herokuapp.com)_

## Support and contact details

_Contact us on Github at [weitzwoman](https://github.com/weitzwoman), [JonathanWThom](https://github.com/JonathanWThom), [JPCodes](https://github.com/JPCodes), [codybru10](https://github.com/codybru10)_

## Technologies Used

* _HTML_
* _CSS_
  * _Materialize_
  * _Bootstrap_
* _Ruby_
  * _Sinatra_
* _ActiveRecord_
* _JavaScript_
  * _JQuery_

### License

BankNotes is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

BankNotes is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with the BankNotes. If not, see http://www.gnu.org/licenses/.

Copyright (c) 2016 **_Tracie Weitzman, Jonathan Thom, Jim Padilla, Cody Brubaker_**
