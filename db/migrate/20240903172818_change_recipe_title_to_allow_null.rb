class ChangeRecipeTitleToAllowNull < ActiveRecord::Migration[7.0]
  def up
    change_column :recipes, :title, :string, null: true
  end

  def down
    change_column :recipes, :title, :string, null: false
  end
end
