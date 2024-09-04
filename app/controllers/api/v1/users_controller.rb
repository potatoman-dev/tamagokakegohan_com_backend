class Api::V1::UsersController < ApplicationController
  def show
    user = User.find_by(name: params[:name])

    if user
      render json: { name: user.name, avatar: user.avatar, nickname: user.nickname, rank: "かけだし" }, status: :ok
    else
      render json: { error: "User not found" }, status: :not_found
    end
  end

  def check_name
    user_name = params[:name]
    if user_name.present?
      is_unique = User.where(name: user_name).empty?
      render json: { is_unique: is_unique }
    end
  end
end
