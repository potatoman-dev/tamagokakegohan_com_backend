class RecipeIngredientSerializer < ActiveModel::Serializer
  attributes :id, :ingredient_name, :amount
  belongs_to :ingredient

  def ingredient_name
    object.ingredient.name
  end
end
