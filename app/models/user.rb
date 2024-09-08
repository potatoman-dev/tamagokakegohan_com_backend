# frozen_string_literal: true

class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User

  validates :password, presence: true, on: :create
  validates :name, presence: true, format: { with: /\A[a-z0-9_-]+\z/ }, uniqueness: true

  mount_uploader :avatar, AvatarUploader

  has_many :recipes, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :bookmarked_recipes, through: :bookmarks, source: :recipe

  #フォローしている
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  # フォローされている
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  # フォローしているユーザーの取得
  has_many :followings, through: :relationships, source: :followed
  # フォロワーの取得
  has_many :followers, through: :reverse_of_relationships, source: :follower
end
