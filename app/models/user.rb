class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :name, presence: true, length: {maximum: 50}
  validates :search_id, uniqueness: true, presence: true 
  
  mount_uploader :avatar, AvatarUploader 
  has_many :following_relationships, foreign_key: "follower_id", class_name: "Relationship",  dependent: :destroy
  has_many :followings, through: :following_relationships
  has_many :follower_relationships, foreign_key: "following_id", class_name: "Relationship", dependent: :destroy
  has_many :followers, through: :follower_relationships
  has_many :entries,dependent: :destroy
  has_many :messages,dependent: :destroy
  has_many :rooms, through: :entries  

  #フォローしているかを確認するメソッド
  def following?(user)
    following_relationships.find_by(following_id: user.id)
  end

  def following
      #@userがフォローしているユーザー
      @user  = User.find(params[:id])
      @users = @user.following
  end

  def follower
      #@userをフォローしているユーザー
      @user  = User.find(params[:id])
      @users = @user.followers
  end

  
  
  def follow(user)
    following_relationships.create!(following_id: user.id)
  end

  #フォローを外すときのメソッド
  def unfollow(user)
    following_relationships.find_by(following_id: user.id).destroy
  end  

  
  def self.search(search)
    return User.all unless search
    User.where(["name LIKE ? OR profile LIKE ?", "%#{search}%", "%#{search}%"]).or(User.where(search_id: "#{search}"))
  end
end
