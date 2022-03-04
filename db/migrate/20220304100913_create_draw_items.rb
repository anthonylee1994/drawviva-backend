class CreateDrawItems < ActiveRecord::Migration[7.0]
  def change
    create_table :draw_items do |t|
      t.references :draw, null: false, foreign_key: true
      t.string :name, null: false
      t.string :image_url

      t.index :name

      t.timestamps
    end
  end
end
