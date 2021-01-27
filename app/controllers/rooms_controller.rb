# frozen_string_literal: true

class RoomsController < ApplicationController
  before_action :authenticate_user!
  before_action :frends, only: %i[show]
  before_action :room_search, only: %i[show]
  before_action :set_room_new, only: %i[show]


  def show
    @message = Message.new
    @current_user_entry = Entry.where(user_id: current_user.id)
    @room = Room.find(params[:id])
    if Entry.where(user_id: current_user.id, room_id: @room.id).present?
      @messages = @room.messages.order(:id).last(15)
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
    @room = Room.create(name: 'DM')
    @entry1 = Entry.create(room_id: @room.id, user_id: current_user.id)
    @entry2 = Entry.create(params.require(:entry).permit(:user_id, :room_id).merge(room_id: @room.id))
    redirect_to room_path(@room.id)
  end

  def destroy
    room = Room.find(params[:id])
    room.destroy
    redirect_to root_path
  end

  def show_additionally
    last_id = params[:post_data][:oldest_message_id].to_i - 1
    @room = Room.find(params[:post_data][:room_id])
    @messages = @room.messages.order(:id).where(id: 1..last_id).last(40)
  end
end
