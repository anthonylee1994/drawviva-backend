# == Schema Information
#
# Table name: users
#
#  id             :bigint           not null, primary key
#  otp_secret_key :string
#  username       :string           not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_users_on_username  (username) UNIQUE
#
class User < ApplicationRecord
  has_one_time_password

  has_one :push_notification_subscription, dependent: :destroy

  validates :username, presence: true, uniqueness: true, allow_blank: false

  before_validation :init_push_notification_subscription, on: :create

  private

  def init_push_notification_subscription
    build_push_notification_subscription
  end
end
