class Api::V1::UsersController < ApplicationController
  def check_name
    user_name = params[:name]
    if user_name.present?
      is_unique = User.where(name: user_name).empty?
      render json: { is_unique: is_unique }
    end
  end
end
