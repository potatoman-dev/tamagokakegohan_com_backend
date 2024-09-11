class Recipe < ApplicationRecord
  belongs_to :user

  has_many :steps, dependent: :destroy

  has_many :recipe_ingredients, dependent: :destroy
  has_many :ingredients, through: :recipe_ingredients

  has_many :bookmarks, dependent: :destroy
  has_many :likes, dependent: :destroy

  validates :title, length: { maximum: 100 }
  validates :title, presence: true, if: :published?
  validates :cooking_time, numericality: { only_integer: true }
  validates :status, presence: true
  enum status: { draft: 0, published: 1 }

  mount_uploader :image, RecipeImageUploader

  scope :highlight_recipes, -> (day){
    joins(:bookmarks)
    .where('bookmarks.created_at >= ?', day.week.ago)
    .where(status: :published)
    .group('recipes.id')
    .order('COUNT(bookmarks.id) DESC')
  }

  scope :new_recipes, -> (day){
    where("created_at > ?", day.days.ago)
    .where(status: :published)
    .order(created_at: :desc)
  }

  scope :fast_recipes, -> (sec){
    where("cooking_time < ?", sec)
    .where(status: :published)
    .order(updated_at: :desc)
  }

  scope :halloffame_recipes, -> (count){
    joins(:likes)
    .where(status: :published)
    .group('recipes.id')
    .having('COUNT(likes.id) >= ?', count)
    .order('COUNT(likes.id) DESC')
  }
end
