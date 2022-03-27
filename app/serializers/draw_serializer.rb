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
class DrawSerializer < ActiveModel::Serializer
  attributes %w[id name image_url created_at updated_at user_draw]

  has_many :draw_items
  has_many :user_draws

  def user_draw
    object.user_draws.find { |user_draw| user_draw.user == current_user }
  end
end
