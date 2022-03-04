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
  let(:anthony) { User.create!(email: 'hososlch@gmail.com', display_name: 'Anthony') }
  let(:ken) { User.create!(email: 'kencckw@gmail.com', display_name: 'Ken') }
  let(:draw) { anthony.draws.create!(name: 'New Draw') }

  example 'create draw' do
    expect(draw.name).to eq 'New Draw'
    expect(draw.users.include?(anthony)).to be_truthy
    expect(draw.admins.include?(anthony)).to be_truthy
    expect(draw.participants.include?(anthony)).to be_falsy
  end

  example 'manage participant' do
    draw.add_participant!(ken)
    expect(draw.users.include?(ken)).to be_truthy
    expect(draw.participants.include?(ken)).to be_truthy
    expect(draw.admins.include?(ken)).to be_falsy

    expect { draw.add_participant!(ken) }.to raise_error(ActiveRecord::RecordInvalid)
    expect { draw.change_role!(user: anthony, role: 'participant') }.to raise_error(ActiveRecord::RecordInvalid)

    draw.change_role!(user: ken, role: 'admin')
    expect(draw.change_role!(user: anthony, role: 'participant')).to be_truthy

    draw.kick_user!(anthony)

    expect(draw.admins.count).to eq 1
    expect(draw.admins.include?(anthony)).to be_falsy
    expect(draw.admins.include?(ken)).to be_truthy
    expect(draw.users.include?(ken)).to be_truthy

    draw.kick_user!(ken)

    expect(Draw.exists?(draw.id)).to be_falsy
  end
end
