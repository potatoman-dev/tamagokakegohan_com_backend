class Api::V1::RelationshipsController < ApplicationController
  before_action :set_user
  before_action :authenticate_api_v1_user!, only: %i[create destroy]

  # フォロー
  def create
    followed_user = User.find_by(name: params[:name])
    relationship = @user.relationships.build(followed_id: followed_user.id)
    if relationship.save
      render json: relationship, status: :created
    else
      render json: { error: 'Failed to follow' }, status: :not_found
    end
  end

  # フォロー解除
  def destroy
    followed_user = User.find_by(name: params[:name])
    relationship = @user.relationships.find_by(followed_id: followed_user.id)

    if relationship.present?
      relationship.destroy
      head :no_content
    else
      render json: { error: 'Failed to unfollow' }, status: :unprocessable_entity
    end
  end

  # フォロー一覧
  def followings
    user = User.find_by(name: params[:name])
    followings = user.followings
    render json: followings, each_serializer: UserSummarySerializer, status: :ok
  end

  # フォロワー一覧
  def followers
    user = User.find_by(name: params[:name])
    followers = user.followers
    render json: followers, each_serializer: UserSummarySerializer, status: :ok
  end

  def is_user_followed
    target_user = User.find_by(name: params[:name])
    is_followed = @user.relationships.exists?(followed_id: target_user)
    render json: { is_followed: is_followed }
  end

  private
  def set_user
    @user = current_api_v1_user
  end
end
