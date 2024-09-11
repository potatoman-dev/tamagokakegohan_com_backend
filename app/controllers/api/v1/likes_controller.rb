class Api::V1::LikesController < ApplicationController
  before_action :set_user
  before_action :authenticate_api_v1_user!, only: %i[create update destroy]

  def index
    likes = @user.liked_recipes
    render json: likes, each_serializer: RecipeSerializer, status: :ok
  end

  def create
    recipe = Recipe.find(params[:id])
    like = recipe.likes.build(user_id: @user.id)

    if like.save
      render json: like, status: :created
    else
      render json: { errors: 'already likeed' }, status: :unprocessable_entity
    end
  end

  def destroy
    like = @user.likes.find_by(recipe: params[:id])

    if like.present?
      like.destroy
      head :no_content
    else
      render json: { error: 'Failed to delete like' }, status: :unprocessable_entity
    end
  end

  private
  def set_user
    @user = current_api_v1_user
  end
end
