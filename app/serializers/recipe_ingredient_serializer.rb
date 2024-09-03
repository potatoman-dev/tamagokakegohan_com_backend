class RecipeIngredientSerializer < ActiveModel::Serializer
  attributes :id, :ingredient_name, :amount
  belongs_to :ingredient, serializer: IngredientSerializer

  def ingredient_name
    object.ingredient.name
  end
end
