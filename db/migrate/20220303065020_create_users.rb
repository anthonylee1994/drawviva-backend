class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :display_name, null: false
      t.string :photo_url, null: true

      t.index :email, unique: true
      t.timestamps
    end
  end
end
