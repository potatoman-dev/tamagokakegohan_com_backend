class CreateRecipes < ActiveRecord::Migration[7.0]
  def change
    create_table :recipes do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title, null: false
      t.text :body
      t.integer :cooking_time
      t.string :image
      t.integer :status, null: false, default: 0

      t.timestamps
    end
  end
end
