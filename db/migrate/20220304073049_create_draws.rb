class CreateDraws < ActiveRecord::Migration[7.0]
  def change
    create_table :draws do |t|
      t.string :name, null: false
      t.string :image_url

      t.index :name

      t.timestamps
    end
  end
end
