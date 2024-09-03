class Recipe < ApplicationRecord
  belongs_to :user

  has_many :steps, dependent: :destroy
  accepts_nested_attributes_for :steps, allow_destroy: true

  has_many :ingredients, through: :recipe_ingredients
  has_many :recipe_ingredients, dependent: :destroy
  accepts_nested_attributes_for :recipe_ingredients, allow_destroy: true

  validates :title, length: { maximum: 100 }
  validates :cooking_time, numericality: { only_integer: true }
  validates :status, presence: true
  enum status: { draft: 0, published: 1 }

  mount_uploader :image, RecipeImageUploader
end
