# frozen_string_literal: true

module Users
  class SearchesController < ApplicationController
    before_action :frends, only: [:index]
    def index
      @users = User.search(params[:keyword])
      frends_ids = []
      @frends.each do |frend|
        frends_ids << frend.id
      end
      @users = @users.page(params[:page]).per(10)
      @follows = current_user.followings.where.not(id: frends_ids)
      @followers = current_user.followers.where.not(id: frends_ids)
      respond_to do |format|
        format.html
        format.json
      end
    end
  end
end
