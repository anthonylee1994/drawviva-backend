# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FirebaseAuthService, type: :service do
  example 'user should have username' do
    response = FirebaseAuthService.verify!('token')

    expect(
      response.dig(:users, 0).slice(
        :display_name,
        :email,
        :photo_url
      )
    ).to(
      eq(
        email: 'user@example.com',
        display_name: 'User',
        photo_url: 'photoUrl'
      )
    )
  end
end
