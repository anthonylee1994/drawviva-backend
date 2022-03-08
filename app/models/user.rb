# frozen_string_literal: true

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
  has_many :user_draws, class_name: 'UserDraw', foreign_key: :user_id, inverse_of: :user, dependent: :destroy

  has_many :admin_user_draws, lambda {
    where(role: 'admin')
  }, class_name: 'UserDraw', foreign_key: :user_id, inverse_of: :user, dependent: :destroy

  has_many :participant_user_draws, lambda {
    where(role: 'participant')
  }, class_name: 'UserDraw', foreign_key: :user_id, inverse_of: :user, dependent: :destroy

  has_many :draws, class_name: 'Draw', through: :user_draws, source: :draw, inverse_of: :users
  has_many :admin_draws, class_name: 'Draw', through: :admin_user_draws, source: :draw, inverse_of: :users
  has_many :participant_draws, class_name: 'Draw', through: :participant_user_draws, source: :draw, inverse_of: :users

  validates :email, presence: true, uniqueness: true, allow_blank: false

  before_validation :init_subscription, on: :create

  accepts_nested_attributes_for :push_notification_subscription, update_only: true

  def token
    JwtService.encode(user_id: id)
  end

  def self.from_token(token)
    decoded_auth_token = JwtService.decode(token)
    User.find_by!(id: decoded_auth_token['user_id'])
  end

  private

  def init_subscription
    build_push_notification_subscription
  end
end
