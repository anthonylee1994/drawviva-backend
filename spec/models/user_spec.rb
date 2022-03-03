# == Schema Information
#
# Table name: users
#
#  id             :bigint           not null, primary key
#  otp_secret_key :string
#  username       :string           not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_users_on_username  (username) UNIQUE
#
require 'rails_helper'

RSpec.describe User, type: :model do
  example 'user should have otp key' do
    user = User.create!(username: 'asshole')
    expect(user.otp_secret_key).not_to be_nil
  end

  example 'user should have username' do
    expect { User.create!(username: nil) }.to raise_error(ActiveRecord::RecordInvalid)
    expect { User.create!(username: '') }.to raise_error(ActiveRecord::RecordInvalid)
  end
end
