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
class UserDrawSerializer < ActiveModel::Serializer
  attributes :id, :draw_id, :role, :created_at, :updated_at
  has_one :user
end
