class CreateSteps < ActiveRecord::Migration[7.0]
  def change
    create_table :steps do |t|
      t.references :recipe, null: false, foreign_key: true
      t.integer :step_number, null: false
      t.text :instruction, null: false
      t.string :image

      t.timestamps
    end
  end
end
