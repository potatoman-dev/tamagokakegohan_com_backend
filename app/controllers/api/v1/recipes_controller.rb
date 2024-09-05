class Api::V1::RecipesController < ApplicationController
  before_action :set_user
  before_action :authenticate_api_v1_user!, only: %i[create update delete]

  def index
    recipes = Recipe.where(status: :published).all
    render json: recipes, each_serializer: RecipeSerializer, status: :ok
  end

  def user
    user = User.find_by(name: params[:name])

      if user == @user
        recipes = user.recipes.all
      else
        recipes = user.recipes.where(status: :published).all
      end

    if recipes
      render json: recipes, each_serializer: RecipeSerializer, status: :ok
    else
      render json: { error: "Recipe not found" }, status: :not_found
    end
  end

  def show
    recipe = Recipe.find_by(id: params[:id])
    if recipe&.user == @user
      recipe
    else
      recipe = Recipe.find_by(id: params[:id], status: :published)
    end

    if recipe
      render json: recipe, serializer: RecipeSerializer,status: :ok
    else
      render json: { error: "Recipe not found" }, status: :not_found
    end
  end

  def create
    Recipe.transaction do
      @recipe = @user.recipes.build(
        title: recipe_params[:title],
        body:recipe_params[:body],
        cooking_time: recipe_params[:cooking_time],
        image: recipe_params[:image],
        status: recipe_params[:status]
      )

      if @recipe.save
        # steps
        steps_attributes = recipe_params[:steps].to_h.values.map { |step|
          {
            recipe_id: @recipe.id,
            step_number: step[:step_number],
            instruction: step[:instruction],
            image: step[:image]
          }
        }
        steps = Step.create!(steps_attributes)
        @recipe.steps = steps

        # ingredients
        ingredients_attributes = recipe_params[:ingredients].to_h.values.map { |ingredient_param|
          ingredient = Ingredient.find_or_create_by(name: ingredient_param[:name])

          {
            recipe_id: @recipe.id,
            ingredient_id: ingredient.id,
            amount: ingredient_param[:amount]
          }
        }

        ingredients = RecipeIngredient.create!(ingredients_attributes)
        @recipe.recipe_ingredients = ingredients

        render json: @recipe, serializer: RecipeSerializer, status: :created
      else
        render json: { errors: @recipe.errors.full_messages }, status: :unprocessable_entity
      end
    rescue ActiveRecord::RecordInvalid => e
      render json: { errors: e.record.errors }, status: :unprocessable_entity
    end
  end

  def update
    @recipe = @user.recipes.find(params[:id])

    if @recipe.update(recipe_params)
      render json: @recipe, serializer: RecipeSerializer,  status: :ok
    else
      render json: @recipe.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @recipe = @user.recipes.find(params[:id])
    if @recipe.destroy
      head :no_content
    else
      render json: { error: 'Failed to delete recipe' }, status: :unprocessable_entity
    end
  end

  private
  def set_user
    @user = current_api_v1_user
  end

  def recipe_params
    params.require(:recipe).permit(
        :title,
        :body,
        :cooking_time,
        :image,
        :status,
        steps: [:step_number, :instruction, :image],
        ingredients: [:name, :amount]
      )
  end
end
