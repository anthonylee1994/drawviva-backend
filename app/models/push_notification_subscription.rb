# == Schema Information
#
# Table name: push_notification_subscriptions
#
#  id         :bigint           not null, primary key
#  auth       :string
#  endpoint   :string
#  p256dh     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_push_notification_subscriptions_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class PushNotificationSubscription < ApplicationRecord
  belongs_to :user
end
