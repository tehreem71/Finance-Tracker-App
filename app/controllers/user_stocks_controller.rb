class UserStocksController < ApplicationController
    #will work when we search a new stock and want to add it to "my portfolio", it will go to the "new_lookup"
    #method and get a complete object for this stock and save it to our table
    def create
        stock=Stock.check_db(params[:ticker]) #see if stock exists or not
        if stock.blank?
            stock=Stock.new_lookup(params[:ticker]) #in case stock doesnt exist in db ,make new one & save
            stock.save
        end
        @user_stock=UserStock.create(user:current_user,stock:stock)
        flash[:notice]="Stock #{stock.name} has been added to your portfolio"
        redirect_to my_portfolio_path #show updated portfolio now
    end
    def destroy
        stock=Stock.find(params[:id])
        user_stock=UserStock.where(user_id: current_user.id, stock_id: stock.id).first
        user_stock.destroy
        flash[:notice]="#{stock.ticker} was successfully removed from portfolio"
        redirect_to my_portfolio_path
    end
end
