# frozen_string_literal: true

class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User

  validates :password, presence: true, on: :create
  validates :name, presence: true, format: { with: /\A[a-z0-9_-]+\z/ }, uniqueness: true

  mount_uploader :avatar, AvatarUploader

  has_many :recipes, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
end
