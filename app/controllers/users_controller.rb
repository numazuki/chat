# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :frends, only: %i[index show]
  before_action :room_search, only: %i[index show]
  before_action :set_room_new, only: %i[index show]

  def index
    @users = User.page(params[:page]).per(10)
    frends_ids = []
    @frends.each do |frend|
      frends_ids << frend.id
    end
    @follows = current_user.followings.where.not(id: frends_ids)
    @followers = current_user.followers.where.not(id: frends_ids)
  end

  def show
    @user = User.find(params[:id])
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

  private

  def user_params
    params.fetch(:user, {}).permit(:name, :avatar, :profile, :search_id)
  end
end
