class Recipe < ApplicationRecord
  belongs_to :user

  has_many :steps, dependent: :destroy

  has_many :recipe_ingredients, dependent: :destroy
  has_many :ingredients, through: :recipe_ingredients

  validates :title, length: { maximum: 100 }
  validates :title, presence: true, if: :published?
  validates :cooking_time, numericality: { only_integer: true }
  validates :status, presence: true
  enum status: { draft: 0, published: 1 }

  mount_uploader :image, RecipeImageUploader
end
