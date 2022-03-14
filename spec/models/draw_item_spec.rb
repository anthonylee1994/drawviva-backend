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
require 'rails_helper'

RSpec.describe DrawItem, type: :model do
  let(:user_one) { User.create!(email: 'user@example.com', display_name: 'User A') }
  let(:draw) { user_one.draws.create!(name: 'New Draw') }

  example 'create draw items' do
    draw_item = draw.draw_items.create!(name: 'New Draw Item')
    expect(draw_item.name).to eq 'New Draw Item'
  end

  example 'make a draw' do
    draw.draw_items.create!(name: 'AAA')
    draw.draw_items.create!(name: 'BBB')
    draw.draw_items.create!(name: 'CCC')

    expect(draw.random_pick!(user_one)).not_to be_nil
  end
end
