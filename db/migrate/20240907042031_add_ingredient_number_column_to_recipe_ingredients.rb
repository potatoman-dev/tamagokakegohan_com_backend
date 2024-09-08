class AddIngredientNumberColumnToRecipeIngredients < ActiveRecord::Migration[7.0]
  def up
    add_column :recipe_ingredients, :ingredient_number, :integer, null: false
  end

  def down
    remove_column :recipe_ingredients, :ingredient_number, :integer, null: false
  end
end
