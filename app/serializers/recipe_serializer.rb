class RecipeSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :cooking_time, :image, :status
  has_many :steps, serializer: StepSerializer
end
