class Ingredient < ApplicationRecord
  has_many :recipes, through: :recipe_ingredients
  validates :name, presence: true, uniqueness: true
end
