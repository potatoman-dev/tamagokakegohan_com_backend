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
      @recipe = @user.recipes.build(basic_recipe_params)

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
        ingredients_attributes = recipe_params[:ingredients].to_h.values.map.with_index { |ingredient_param, index|
          ingredient = Ingredient.find_or_create_by(name: ingredient_param[:name])

          {
            recipe_id: @recipe.id,
            ingredient_id: ingredient.id,
            ingredient_number: index + 1,
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

    ActiveRecord::Base.transaction do
      if @recipe.update(basic_recipe_params)
        # steps
          steps_attributes = recipe_params[:steps].to_h.values.map { |step|
            {
              recipe_id: @recipe.id,
              step_number: step[:step_number],
              instruction: step[:instruction],
              image: step[:image]
            }
          }

          # 存在しているかどうか
          new_step_numbers = steps_attributes.map { |attr|
            attr[:step_number].to_i
          }
          # 不要なステップを削除
          @recipe.steps.where.not(step_number: new_step_numbers).destroy_all

          steps_attributes.each do |attr|
            # 存在している場合
            existing_step = @recipe.steps.find_by(step_number: attr[:step_number])

            if existing_step
              # 更新
              existing_step.update!(
                instruction: attr[:instruction],
                image: attr[:image]
                )
            else
              # 追加
              @recipe.steps.create!(
                step_number: attr[:step_number],
                instruction: attr[:instruction],
                image: attr[:image]
              )
            end
          end

        # ingredients
          ingredients_attributes = recipe_params[:ingredients].to_h.values.map.with_index { |recipe_ingredient, index|
          ingredient = Ingredient.find_or_create_by(name: recipe_ingredient[:name])

            {
              recipe_id: @recipe.id,
              ingredient_id: ingredient.id,
              ingredient_number: index + 1,
              amount: recipe_ingredient[:amount]
            }
          }

          # 存在しているかどうか
          new_ingredient_numbers = ingredients_attributes.map.with_index { |attr, index|
            index + 1
          }
          # 不要なrecipe_ingredientを削除
          @recipe.recipe_ingredients.where.not(ingredient_number: new_ingredient_numbers).destroy_all

          ingredients_attributes.each_with_index do |attr, index|
            # 存在している場合
            existing_ingredient = @recipe.recipe_ingredients.find_by(ingredient_number: index + 1)


            if existing_ingredient
              # 更新
              existing_ingredient.update!(
                ingredient_id: attr[:ingredient_id],
                amount: attr[:amount]
              )
            else
              # 追加
              @recipe.recipe_ingredients.create!(
                ingredient_id: attr[:ingredient_id],
                ingredient_number: index + 1,
                amount: attr[:amount]
              )
            end
          end

        render json: @recipe, serializer: RecipeSerializer,  status: :ok
      else
        render json: @recipe.errors, status: :unprocessable_entity
      end
    rescue ActiveRecord::RecordInvalid => e
      render json: { errors: e.record.errors }, status: :unprocessable_entity
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

  def basic_recipe_params
    params.require(:recipe).permit(
        :title,
        :body,
        :cooking_time,
        :image,
        :status
      )
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
