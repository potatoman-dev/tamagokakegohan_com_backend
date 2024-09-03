class StepSerializer < ActiveModel::Serializer
  attributes :id, :step_number, :instruction, :image
  belongs_to :recipe, serializer: RecipeSerializer
end
