class RecipeSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :cooking_time, :image, :status
  has_many :steps, serializer: StepSerializer
  has_many :recipe_ingredients, serializer: RecipeIngredientSerializer
  belongs_to :user, serializer: UserSummarySerializer
end
