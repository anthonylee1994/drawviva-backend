require 'rails_helper'

RSpec.describe 'Auths', type: :request do
  example 'login' do
    post '/login', params: { token: 'token' }
    json_body = JSON.parse(response.body)
    expect(json_body['display_name']).to eq 'User'
    expect(json_body['email']).to eq 'user@example.com'
    expect(json_body['photo_url']).to eq 'photoUrl'
    expect(JwtService.decode(response.headers['Authorization'].split(' ').last)).to eq('user_id' => User.last.id)
  end
end
