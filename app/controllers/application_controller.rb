class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  def self.render_with_signed_in_user(user, *args)
    ActionController::Renderer::RACK_KEY_TRANSLATION['warden'] ||= 'warden'
    proxy = Warden::Proxy.new({}, Warden::Manager.new({})).tap{|i| i.set_user(user, scope: :user) }
    renderer = self.renderer.new('warden' => proxy)
    renderer.render(*args)
  end 
  
  

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :search_id, :profile,:avatar])
  end

  
  private

  def frends
    if params[:frend_keyword]
      @name = User.where('name LIKE ?', "%#{params[:frend_keyword]}%")
      @frends = @name & current_user.followings & current_user.followers
    else
      @frends = current_user.followings & current_user.followers
    end
  end

  def room_search
    @currentEntries = current_user.entries
    #@currentEntriesのルームを配列にする
    myRoomIds = []
    @currentEntries.each do |entry|
      # <<は配列の最後に追加するよ
      myRoomIds << entry.room.id
    end
    if params[:room_keyword].present?
      @search_room = Message.where(content: "#{params[:room_keyword]}").pluck(:room_id)
      @search_room_ids = @search_room & myRoomIds
      @anotherEntries = Entry.where(room_id: @search_room_ids).where.not(user_id: current_user.id)
      @section_number = 2
      #binding.pry
    else
      @anotherEntries = Entry.where(room_id: myRoomIds).where.not(user_id: current_user.id).order(created_at: :desc)
    end   
  end

  
  def room(user) 
    if user_signed_in?
      #Entry内のuser_idがcurrent_userと同じEntry
      @currentUserEntry = Entry.where(user_id: current_user.id)
      #Entry内のuser_idがMYPAGEのparams.idと同じEntry
      @userEntry = Entry.where(user_id: user.id)
        #@user.idとcurrent_user.idが同じでなければ
        unless user.id == current_user.id
          @currentUserEntry.each do |cu|
            @userEntry.each do |u|
              #もしcurrent_user側のルームidと＠user側のルームidが同じであれば存在するルームに飛ぶ
              if cu.room_id == u.room_id then
                @isRoom = true
                @roomId = cu.room_id
              end
            end
          end
          #binding.pry
          #ルームが存在していなければルームとエントリーを作成する
          unless @isRoom
            @room = Room.new
            @entry = Entry.new
          end
        end
    end 
  end
    
  def room2 
    if user_signed_in?
      #Entry内のuser_idがcurrent_userと同じEntry
      @currentUserEntry = Entry.where(user_id: current_user.id)
      #Entry内のuser_idがMYPAGEのparams.idと同じEntry
      @user_all = User.all
      @user_all.each do |user|
        @userEntry = Entry.where(user_id: user.id)
        @currentUserEntry.each do |cu|
          @userEntry.each do |u|
            #もしcurrent_user側のルームidと＠user側のルームidが同じであれば存在するルームに飛ぶ
            if cu.room_id == u.room_id then
              @isRoom = true
              @roomId = cu.room_id
            end
          end
        end
        unless @isRoom
          @room = Room.new
          @entry = Entry.new
        end
      end
    end
  end
end
