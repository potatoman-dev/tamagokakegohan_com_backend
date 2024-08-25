class CreateS3tests < ActiveRecord::Migration[7.0]
  def change
    create_table :s3tests do |t|
      t.string :image

      t.timestamps
    end
  end
end
