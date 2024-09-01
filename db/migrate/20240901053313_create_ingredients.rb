class CreateIngredients < ActiveRecord::Migration[7.0]
  def change
    create_table :ingredients do |t|
      t.references :category, null: false, foreign_key: true
      t.string :name, null: false

      t.timestamps
    end
  end
end
