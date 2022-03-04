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
  has_many :user_draws, class_name: 'UserDraw', dependent: :destroy
  has_many :admin_user_draws, -> { where(role: 'admin') }, class_name: 'UserDraw', dependent: :destroy
  has_many :participant_user_draws, -> { where(role: 'participant') }, class_name: 'UserDraw', dependent: :destroy
  has_many :users, through: :user_draws, source: :user
  has_many :admins, through: :admin_user_draws, source: :user
  has_many :participants, through: :participant_user_draws, source: :user
  has_many :draw_items, dependent: :destroy

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
