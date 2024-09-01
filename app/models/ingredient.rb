class Ingredient < ApplicationRecord
  belongs_to :category
  has_many :recipes, through: :recipe_ingredients
  validates :name, presence: true, uniqueness: true
end
