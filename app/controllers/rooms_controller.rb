class RoomsController < ApplicationController
before_action :authenticate_user!
before_action :frends, only: [:index,:show]
before_action :room_search, only: [:index, :show]

  def index
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
    @room_new = Room.new
    @entry_new = Entry.new    
  end

  def show

    @message = Message.new
    #@currentEntriesのルーム且つcurrent_userでないEntryを新着順で取ってくる
    @currentUserEntry = Entry.where(user_id: current_user.id) 
    
    @room = Room.find(params[:id])
    #ルームが作成されているかどうか
    @room_new = Room.new
    @entry_new = Entry.new  
    if Entry.where(:user_id => current_user.id, :room_id => @room.id).present?
      @messages = @room.messages.order(:id).last(30)
      @entries = @room.entries
    else
      redirect_back(fallback_location: root_path)
    end
    @range = Date.yesterday.beginning_of_day..Date.yesterday.end_of_day


    
  end
  
  def new
    @room = Room.new
  end

  def create
    @room = Room.create(:name => "DM")
    #entryにログインユーザーを作成
    @entry1 = Entry.create(:room_id => @room.id, :user_id => current_user.id)
    #entryにparamsユーザーを作成
    @entry2 = Entry.create(params.require(:entry).permit(:user_id, :room_id).merge(:room_id => @room.id))
    redirect_to room_path(@room.id)
  end

  def destroy
    room = Room.find(params[:id])
    room.destroy
    redirect_to rooms_path
  end
  
  
  def show_additionally
    last_id = params[:post_data][:oldest_message_id].to_i - 1 
    #binding.pry
    @room = Room.find(params[:post_data][:room_id])
    @messages = @room.messages.order(:id).where(id: 1..last_id).last(40)
  end    
  private
  

     
  
end
