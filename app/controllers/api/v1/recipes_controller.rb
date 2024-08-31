class Api::V1::RecipesController < ApplicationController
  before_action :set_user
  before_action :authenticate_api_v1_user!, only: %i[create update delete]

  def index
    recipes = Recipe.all
    render json: recipes, status: :ok
  end

  def create
    @recipe = @user.recipes.build(recipe_params)
    if @recipe.save
      render json: @recipe, status: :created
    else
      render json: { errors: @recipe.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
  end

  def delete
  end

  private
  def set_user
    @user = current_api_v1_user
  end

  def recipe_params
    params.require(:recipe).permit(:title, :body, :cooking_time, :image, :status)
  end
end
