# frozen_string_literal: true

class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User

  validates :password, presence: true, on: :create
  validates :name, presence: true, format: { with: /\A[a-z0-9_-]+\z/ }, uniqueness: true
  validates :introduction, length: { maximum: 200 }

  mount_uploader :avatar, AvatarUploader

  has_many :recipes, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :bookmarked_recipes, through: :bookmarks, source: :recipe
  has_many :likes, dependent: :destroy
  has_many :liked_recipes,through: :likes, source: :recipe

  #フォローしている
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  # フォローされている
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  # フォローしているユーザーの取得
  has_many :followings, through: :relationships, source: :followed
  # フォロワーの取得
  has_many :followers, through: :reverse_of_relationships, source: :follower

  def rank(user_recipes)
    recipes_count = user_recipes.where(status: :published).count
    case recipes_count
    when 0...5
      "かけだし"
    when 5...10
      "見習い"
    when 10...20
      "1つ星"
    when 20...30
      "2つ星"
    else
      "3つ星"
    end
  end
end
