class StepSerializer < ActiveModel::Serializer
  attributes :id, :instruction, :image, :step_number
  belongs_to :recipe, serializer: RecipeSerializer
end
