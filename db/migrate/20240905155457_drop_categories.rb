class DropCategories < ActiveRecord::Migration[7.0]
  def change
    drop_table :categories do |t|
      t.string "name", null: false
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end
  end
end
