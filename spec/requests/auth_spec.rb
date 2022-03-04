require 'rails_helper'

RSpec.describe 'Auths', type: :request do
  example 'login' do
    post '/login', params: { token: 'token' }
    json_body = JSON.parse(response.body)
    expect(json_body['display_name']).to eq 'Anthony Lee'
    expect(json_body['email']).to eq 'hososlch@gmail.com'
    expect(json_body['photo_url']).to eq 'https://lh3.googleusercontent.com/a/AATXAJw8AfrjlDZ3mjs7kYjnj8NuJhErXBhKpmPM-lnzgQ=s96-c'
    expect(JwtService.decode(response.headers['Authorization'].split(' ').last)).to eq('user_id' => User.last.id)
  end
end
