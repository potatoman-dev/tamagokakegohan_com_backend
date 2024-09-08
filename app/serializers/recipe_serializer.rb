class RecipeSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :cooking_time, :image, :status, :bookmark_count, :created_at
  has_many :steps, serializer: StepSerializer
  has_many :recipe_ingredients, serializer: RecipeIngredientSerializer
  belongs_to :user, serializer: UserSummarySerializer

  def bookmark_count
    object.bookmarks.count
  end
end
