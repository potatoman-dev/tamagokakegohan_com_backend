class DropCategories < ActiveRecord::Migration[7.0]
  def change
    remove_foreign_key :ingredients, :categories
    remove_reference :ingredients, :category, index: true

    drop_table :categories do |t|
      t.string "name", null: false
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end
  end
end
