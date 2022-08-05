class User < ApplicationRecord
  has_many :user_stocks
  has_many :stocks, through: :user_stocks
  has_many :friendships
  has_many :friends ,through: :friendships
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable


  def stock_already_tracked?(ticker_symbol)
    stock=Stock.check_db(ticker_symbol)  #see if stock exists in db, if yes then store in "stock" obj
    return false unless stock #if doesnt exist
    stocks.where(id: stock.id).exists?  #see if user has that stock associated with them or not
  end

  def under_stock_limit? #limit is 10
    stocks.count <10
  end
  #used in _result.html for "add to portfolio" button
  def can_track_stock?(ticker_symbol)
    #if true, then less than 10, else returns false
    #stock_already_tracker?(ticker_symbol) returns true if user is already tracking stock
    #using !stock_already_tracker?(ticker_symbol) because we need to get stocks that user is NOT already tracking
    #cuz that would already be in the portfolio
    under_stock_limit? && !stock_already_tracked?(ticker_symbol) 
  end
  def full_name
    return "#{first_name} #{last_name}" if first_name || last_name
    "Anonymous"
  end
  def self.search(param)
    param.strip! #get rid of empty spaces before or after
    #checking to match ANY field : first name,last name, email
    #will check all fields by calling methods and get all
    to_send_back=(first_name_matches(param)+last_name_matches(param)+email_matches(param)).uniq #to get 1 unique value
    return nil unless to_send_back #if nothing to send back
    to_send_back #returning if not nill , no need to write "return"

  end
  def self.first_name_matches(param)
    matches('first_name',param)
  end
  def self.last_name_matches(param)
    matches('last_name',param)
  end
  def self.email_matches(param)
    matches('email',param)
  end

  def self.matches(field_name,param) #field_name is email,name etc to search from, param is whatever is entered in search bar
    where("#{field_name} like ?", "%#{param}%")  #search for everything related, just like in SQL
  end
  def except_current_user(users)
    users.reject{|user| user.id==self.id} #current user 
  end
  def not_friends_with?(id_of_friend) #check if friend already exists for user or not
    !self.friends.where(id: id_of_friend).exists? #return true if NOT friends
  end

end
