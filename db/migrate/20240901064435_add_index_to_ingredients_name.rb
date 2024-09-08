class AddIndexToIngredientsName < ActiveRecord::Migration[7.0]
  def change
    add_index :ingredients, :name, unique: true
  end
end
