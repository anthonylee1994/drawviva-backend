# == Schema Information
#
# Table name: users
#
#  id           :bigint           not null, primary key
#  display_name :string           not null
#  email        :string           not null
#  photo_url    :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#
require 'rails_helper'

RSpec.describe User, type: :model do
  example 'user should have username' do
    expect { User.create!(email: nil) }.to raise_error(ActiveRecord::RecordInvalid)
    expect { User.create!(email: '') }.to raise_error(ActiveRecord::RecordInvalid)
  end
end
