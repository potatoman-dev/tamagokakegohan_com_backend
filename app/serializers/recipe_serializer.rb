class RecipeSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :cooking_time, :image, :status
  has_many :steps
  has_many :recipe_ingredients
end
