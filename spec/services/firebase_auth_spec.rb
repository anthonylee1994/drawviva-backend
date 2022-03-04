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
        email: 'hososlch@gmail.com',
        display_name: 'Anthony Lee',
        photo_url: 'https://lh3.googleusercontent.com/a/AATXAJw8AfrjlDZ3mjs7kYjnj8NuJhErXBhKpmPM-lnzgQ=s96-c'
      )
    )
  end
end
