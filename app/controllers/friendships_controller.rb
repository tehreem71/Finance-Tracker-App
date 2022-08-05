class FriendshipsController < ApplicationController
  def create
    friend=User.find(params[:friend])
    current_user.friendships.build(friend_id: friend.id)
    if current_user.save
      flash[:notice]="Following user!"
    else
      flash[:alert]="An error occured while tracking request"
    end
    redirect_to my_friends_path
  end

  def destroy
    friendship=current_user.friendships.where(friend_id: params[:id]).first #first to get 1 object
    friendship.destroy
    flash[:notice]="Stopped following"
    redirect_to my_friends_path
  end
end
