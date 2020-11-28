class Users::SearchesController < ApplicationController
before_action :frends, only: [:index]  
  def index
    # ↓検索処理のコード
    
    @users = User.search(params[:keyword])
    frendsIds = []
    @frends.each do |frend|
      frendsIds << frend.id
    end    
    @users = @users.page(params[:page]).per(10)
    @follows = current_user.followings.where.not(id: frendsIds)
    @followers= current_user.followers.where.not(id: frendsIds)      

    #binding.pry
    respond_to do |format|
      format.html
      format.json
    end
  end
  
  
  
  
end