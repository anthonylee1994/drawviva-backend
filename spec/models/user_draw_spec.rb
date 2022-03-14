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
require 'rails_helper'

RSpec.describe UserDraw, type: :model do
  let(:user_one) { User.create!(email: 'user@example.com', display_name: 'User A') }
  let(:user_two) { User.create!(email: 'otheruser@gmail.com', display_name: 'User B') }
  let(:draw) { user_one.draws.create!(name: 'New Draw') }

  example 'create draw' do
    expect(draw.name).to eq 'New Draw'
    expect(draw.users.include?(user_one)).to be_truthy
    expect(draw.admins.include?(user_one)).to be_truthy
    expect(draw.participants.include?(user_one)).to be_falsey
  end

  example 'manage participant' do
    draw.add_participant!(user_two)
    expect(draw.users.include?(user_two)).to be_truthy
    expect(draw.participants.include?(user_two)).to be_truthy
    expect(draw.admins.include?(user_two)).to be_falsey

    expect { draw.add_participant!(user_two) }.to raise_error(ActiveRecord::RecordInvalid)
    expect { draw.change_role!(user: user_one, role: 'participant') }.to raise_error(ActiveRecord::RecordInvalid)

    draw.change_role!(user: user_two, role: 'admin')
    expect(draw.change_role!(user: user_one, role: 'participant')).to be_truthy

    draw.kick_user!(user_one)

    expect(draw.admins.count).to eq 1
    expect(draw.admins.include?(user_one)).to be_falsey
    expect(draw.admins.include?(user_two)).to be_truthy
    expect(draw.users.include?(user_two)).to be_truthy

    draw.kick_user!(user_two)

    expect(Draw.exists?(draw.id)).to be_falsey
  end
end
