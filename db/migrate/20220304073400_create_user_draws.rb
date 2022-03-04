class CreateUserDraws < ActiveRecord::Migration[7.0]
  def change
    create_table :user_draws do |t|
      t.references :user, null: false, foreign_key: true
      t.references :draw, null: false, foreign_key: true
      t.integer :role, null: false, default: 0

      t.timestamps
    end
  end
end
