# == Schema Information
#
# Table name: users
#
#  id           :bigint           not null, primary key
#  display_name :string           not null
#  email        :string           not null
#  photo_url    :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#
class User < ApplicationRecord

  has_one :push_notification_subscription, dependent: :destroy

  validates :email, presence: true, uniqueness: true, allow_blank: false

  before_validation :init_push_notification_subscription, on: :create

  private

  def init_push_notification_subscription
    build_push_notification_subscription
  end
end
