# frozen_string_literal: true

# == Schema Information
#
# Table name: draws
#
#  id         :bigint           not null, primary key
#  image_url  :string
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_draws_on_name  (name)
#
class Draw < ApplicationRecord
  has_many :user_draws, -> { order(created_at: :asc) }, class_name: 'UserDraw', inverse_of: :draw, dependent: :destroy
  has_many :admin_user_draws, lambda {
    where(role: 'admin')
  }, class_name: 'UserDraw', inverse_of: :draw, dependent: :destroy
  has_many :participant_user_draws, lambda {
    where(role: 'participant')
  }, class_name: 'UserDraw', inverse_of: :draw, dependent: :destroy
  has_many :users, through: :user_draws, source: :user, inverse_of: :draws
  has_many :admins, through: :admin_user_draws, source: :user, inverse_of: :draws
  has_many :participants, through: :participant_user_draws, source: :user, inverse_of: :draws
  has_many :draw_items, -> { order(created_at: :asc) }, dependent: :destroy

  validates :name, presence: true, allow_blank: false

  # @param [User] current_user
  # @return [DrawItem]
  def random_pick!(current_user)
    draw_item = draw_items[RandomService.random_number(draw_items.count)]
    users.each do |user|
      next unless user.push_notification_subscription.receivable?

      user.push_notification_subscription.receive!(
        title: "秒抽「#{name}」",
        message: "#{current_user.display_name} 已抽出 「#{draw_item.name}」！",
        icon_url: draw_item.image_url
      )
    end
    draw_item
  end

  def add_participant!(user)
    user_draws.create!(user:, role: 'participant')
  end

  def add_admin!(user)
    user_draws.create!(user:, role: 'admin')
  end

  def kick_user!(user)
    user_draws.find_by!(user:).destroy!
  end

  def change_role!(user:, role:)
    user_draws.find_by!(user:).update!(role:)
  end
end
