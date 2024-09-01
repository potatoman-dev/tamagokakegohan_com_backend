class Api::V1::IngredientsController < ApplicationController
  before_action :authenticate_api_v1_user!, only: %i[create update delete]

  def index
    ingredients = Ingredient.all
    render json: ingredients, status: :ok
  end

  def create
    ingredient = Ingredient.create(ingredient_params)

    if ingredient.save
      render json: ingredient, status: :created
    else
      render json: { errors: ingredient.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    ingredient = Ingredient.find(params[:id])

    if ingredient
      render json: ingredient, status: :ok
    else
      render json: { errors: "Ingredient not found" }, status: :not_found
    end
  end

  def update
    ingredient = Ingredient.find(params[:id])
    if ingredient.update(ingredient_params)
      render json: ingredient, status: :ok
    else
      render json: { errors: ingredient.errors.full_messages }, status: :bad_request
    end
  end

  def destroy
    ingredient = Ingredient.find(params[:id])
    if ingredient.destroy
      head :no_content
    else
      render json: { error: 'Failed to delete ingredient' }, status: :unprocessable_entity
    end
  end

  private
  def ingredient_params
    params.require(:ingredient).permit(:name, :category_id)
  end
end
