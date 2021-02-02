# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  def self.render_with_signed_in_user(user, *args)
    ActionController::Renderer::RACK_KEY_TRANSLATION['warden'] ||= 'warden'
    proxy = Warden::Proxy.new({}, Warden::Manager.new({})).tap { |i| i.set_user(user, scope: :user) }
    renderer = self.renderer.new('warden' => proxy)
    renderer.render(*args)
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name search_id profile avatar remove_avatar])
  end

  private

  def set_room_new
    @room_new = Room.new
    @entry_new = Entry.new
    @is_room = false
  end

  def frends
    if params[:frend_keyword]
      @search_frend = User.where('name LIKE ?', "%#{params[:frend_keyword]}%")
      @frends = @search_frend & current_user.followings & current_user.followers
    else
      @frends = current_user.followings & current_user.followers
    end
  end

  def room_search
    @current_entries = current_user.entries
    my_room_ids = []
    @current_entries.each do |entry|
      my_room_ids << entry.room.id
    end
    if params[:room_keyword].present?
      @search_room = Message.where(content: params[:room_keyword].to_s).pluck(:room_id)
      @search_room_ids = @search_room & my_room_ids
      @another_entries = Entry.where(room_id: @search_room_ids).where.not(user_id: current_user.id)
      @section_number = 2      
    else
      @another_entries = Entry.where(room_id: my_room_ids).where.not(user_id: current_user.id).order(created_at: :desc)
    end
  end
end
