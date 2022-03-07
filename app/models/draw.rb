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
  has_many :user_draws, class_name: 'UserDraw', inverse_of: :draw, dependent: :destroy
  has_many :admin_user_draws, -> { where(role: 'admin') }, class_name: 'UserDraw', inverse_of: :draw, dependent: :destroy
  has_many :participant_user_draws, -> { where(role: 'participant') }, class_name: 'UserDraw', inverse_of: :draw, dependent: :destroy
  has_many :users, through: :user_draws, source: :user, inverse_of: :draws
  has_many :admins, through: :admin_user_draws, source: :user, inverse_of: :draws
  has_many :participants, through: :participant_user_draws, source: :user, inverse_of: :draws
  has_many :draw_items, dependent: :destroy

  def random_pick!(current_user)
    draw_item = draw_items[RandomService.random_number(draw_items.count)]
    users.where.not(id: current_user.id).each do |user|
      if user.subscription.present?
        NotificationService.send(user.subscription, "#{current_user.display_name} 已抽出 「#{draw_item.name}」！")
      end
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
