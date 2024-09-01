class Api::V1::CategoriesController < ApplicationController
  before_action :authenticate_api_v1_user!, only: %i[create update delete]

  def index
    categories = Category.all
    render json: categories, status: :ok
  end

  def create
    category = Category.create(category_params)

    if category.save
      render json: category, status: :created
    else
      render json: { errors: category.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    category = Category.find(params[:id])

    if category
      render json: category, status: :ok
    else
      render json: { errors: "Category not found" }, status: :not_found
    end
  end

  def update
    category = Category.find(params[:id])
    if category.update(category_params)
      render json: category, status: :ok
    else
      render json: { errors: category.errors.full_messages }, status: :bad_request
    end
  end

  def destroy
    category = Category.find(params[:id])
    if category.destroy
      head :no_content
    else
      render json: { error: 'Failed to delete category' }, status: :unprocessable_entity
    end
  end


  private
  def category_params
    params.require(:category).permit(:name)
  end
end
