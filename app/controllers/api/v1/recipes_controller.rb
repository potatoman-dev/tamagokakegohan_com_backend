class Api::V1::RecipesController < ApplicationController
  before_action :set_user
  before_action :authenticate_api_v1_user!, only: %i[create update delete]

  def index
    recipes = Recipe.all
    render json: recipes, status: :ok
  end

  def show
    recipe = Recipe.find_by(id: params[:id])

    if recipe
      render json: recipe, status: :ok
    else
      render json: { error: "Recipe not found" }, status: :not_found
    end
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
    @recipe = @user.recipes.find(params[:id])

    if @recipe.update(recipe_params)
      render json: @recipe, status: :ok
    else
      render json: @recipe.errors, status: :unprocessable_entity
    end
  end

  def delete
  end

  private
  def set_user
    @user = current_api_v1_user
  end

  def recipe_params
    params.require(:recipe).permit(:title, :body, :cooking_time, :image, :status, steps_attributes: [:id, :step_number, :instruction, :image, :_destroy])
  end
end
