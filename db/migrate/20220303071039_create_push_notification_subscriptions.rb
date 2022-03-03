class CreatePushNotificationSubscriptions < ActiveRecord::Migration[7.0]
  def change
    create_table :push_notification_subscriptions do |t|
      t.string :endpoint
      t.string :p256dh
      t.string :auth
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
