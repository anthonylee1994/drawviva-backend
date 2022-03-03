class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :username, null: false
      t.string :otp_secret_key

      t.index :username, unique: true
      t.timestamps
    end
  end
end
