class UsersController < ApplicationController
  def my_portfolio
    @user=current_user
    @tracked_stocks= current_user.stocks #current_user is a devise helper to get current user
  end
  def my_friends
    @friends= current_user.friends  #get all friends of current user
  end
  def show
    @user=User.find(params[:id])
    @tracked_stocks=@user.stocks
  end

  def search
    if params[:friend].present?
        @friends=User.search(params[:friend])
        @friends=current_user.except_current_user(@friends) #dont display user himself in search result
        if @friends    #in case of a valid search
            respond_to do |format|    
                #accept JS formata, go to partial 'result' which will have the JS code
                format.js {render partial:'users/friend_result'}   
            end
        else      #invalid symbol
            respond_to do |format|    
            flash.now[:alert]="Couldn't find user"  #flash.now occurs for only 1 cycle
            format.js {render partial:'users/friend_result'}
            end
        end
    else         #empty string
        respond_to do |format| 
            flash.now[:alert]="Please enter a friend name or email to search"
            format.js {render partial:'users/friend_result'}
        end
    end
  end
end
