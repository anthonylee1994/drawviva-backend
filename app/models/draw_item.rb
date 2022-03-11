# == Schema Information
#
# Table name: draw_items
#
#  id         :bigint           not null, primary key
#  image_url  :string
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  draw_id    :bigint           not null
#
# Indexes
#
#  index_draw_items_on_draw_id  (draw_id)
#  index_draw_items_on_name     (name)
#
# Foreign Keys
#
#  fk_rails_...  (draw_id => draws.id)
#
class DrawItem < ApplicationRecord
  belongs_to :draw

  validates :name, presence: true, allow_blank: false
end
