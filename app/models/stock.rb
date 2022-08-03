class Stock < ApplicationRecord
    def self.new_lookup(ticker_symbol) #function to look up for price automatically for a given ticker
        client = IEX::Api::Client.new(
            publishable_token: Rails.application.credentials.iex_client[:sandbox_api_key],
            endpoint: 'https://sandbox.iexapis.com/v1')
        client.price(ticker_symbol)  #dont have to write "return" explicitly in rails
    end
end
