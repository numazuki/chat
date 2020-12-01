class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :frends, only: [:index, :show]
  before_action :room_search, only: [:index, :show]


  def index
 
    @users = User.page(params[:page]).per(10)
    frendsIds = []
    @frends.each do |frend|
      frendsIds << frend.id
    end
    @follows = current_user.followings.where.not(id: frendsIds)
    #binding.pry
    @followers= current_user.followers.where.not(id: frendsIds)    
    @room_new = Room.new
    @entry_new = Entry.new
    
    @isRoom = false    

  end
  
  def show
    @user = User.find(params[:id])
    @room_new = Room.new
    @entry_new = Entry.new
    @currentEntries = current_user.entries
    #@currentEntriesのルームを配列にする
    myRoomIds = []
    @currentEntries.each do |entry|
      # <<は配列の最後に追加するよ
      myRoomIds << entry.room.id
    end
    #@currentEntriesのルーム且つcurrent_userでないEntryを新着順で取ってくる
    @anotherEntries = Entry.where(room_id: myRoomIds).where.not(user_id: current_user.id).order(created_at: :desc)
    @isRoom = false  
  end 
  


  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if current_user.update(user_params)
      redirect_to user_path(current_user)
    else
      redirect_to edit_user_path(current_user)
    end  
  end


  
  def follows
    user = User.find(params[:id])
    
  end

  def followers
    user = User.find(params[:id])
    
  end 
  

  
  def not_allowed
    @user = User.find(params[:id])
    @followers = @user.followers.where.not(id:@user.followings.ids).page(params[:page])
  end

  
  private

  def user_params
    params.fetch(:user, {}).permit(:name,:avatar,:profile,:search_id)
  end
  
end
