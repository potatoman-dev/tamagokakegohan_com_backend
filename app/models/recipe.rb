class Recipe < ApplicationRecord
  belongs_to :user
  validates :title, presence: true
  validates :title, length: { maximum: 100 }
  validates :cooking_time, numericality: { only_integer: true }
  validates :status, presence: true
  enum status: { draft: 0, published: 1 }

  mount_uploader :image, RecipeImageUploader
end
