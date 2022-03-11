class DrawSerializer < ActiveModel::Serializer
  attributes %w[id name image_url created_at updated_at user_draw]

  has_many :draw_items
  has_many :user_draws

  def user_draw
    object.user_draws.find { |user_draw| user_draw.user == current_user }
  end
end
