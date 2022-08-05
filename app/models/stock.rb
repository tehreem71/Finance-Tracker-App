class Stock < ApplicationRecord
    has_many :user_stocks
    has_many :users, through: :user_stocks
    
    validates :name, :ticker, presence:true


    def self.new_lookup(ticker_symbol) #function to look up for price automatically for a given ticker
        client = IEX::Api::Client.new(
            publishable_token: Rails.application.credentials.iex_client[:sandbox_api_key],
            endpoint: 'https://sandbox.iexapis.com/v1')
            #client.price(ticker_symbol)  #dont have to write "return" explicitly in rails
        begin
            
            new(ticker:ticker_symbol, name:client.company(ticker_symbol).company_name, last_price:client.price(ticker_symbol))  #dont have to write Stock.new cuz we are already inside the object
        rescue => exception
            return nil
        end
    end
    def self.check_db(ticker_symbol)
        where(ticker: ticker_symbol).first #.first returns object found for given ticker
    end

end
