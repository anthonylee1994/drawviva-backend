# == Schema Information
#
# Table name: user_draws
#
#  id         :bigint           not null, primary key
#  role       :integer          default("participant"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  draw_id    :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_user_draws_on_draw_id  (draw_id)
#  index_user_draws_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (draw_id => draws.id)
#  fk_rails_...  (user_id => users.id)
#
class UserDraw < ApplicationRecord
  belongs_to :user
  belongs_to :draw

  enum role: { participant: 0, admin: 1 }

  validates :user, presence: true, uniqueness: { scope: :draw }
  validate :must_have_one_admin, on: :update, if: -> { role_change == %w[admin participant] }

  before_validation :set_user_as_admin, on: :create, if: -> { draw.admins.empty? }
  after_destroy :set_first_user_as_admin, if: -> { draw.admins.empty? && !draw.users.empty? }
  after_destroy :destroy_draw, if: -> { draw.users.empty? }

  def must_have_one_admin
    errors.add(:base, __method__.to_s) if draw.admins.count == 1 && draw.admins.include?(user)
  end

  def set_user_as_admin
    self.role = 'admin'
  end

  def set_first_user_as_admin
    draw.user_draws.first&.update!(role: 'admin')
  end

  def destroy_draw
    draw.destroy
  end
end
