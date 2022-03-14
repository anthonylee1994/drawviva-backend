# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'UserDraws', type: :request do
  let(:user_one) { User.create!(email: 'user@example.com', display_name: 'User A') }
  let(:user_one_auth_headers) { { 'Authorization': "Bearer #{user_one.token}" } }
  let(:user_two) { User.create!(email: 'otheruser@gmail.com', display_name: 'User B') }
  let(:user_two_auth_headers) { { 'Authorization': "Bearer #{user_two.token}" } }
  let(:hihi) { User.create!(email: 'hihi@gmail.com', display_name: 'Hihi') }
  let(:hihi_auth_headers) { { 'Authorization': "Bearer #{hihi.token}" } }
  let(:draw) { user_one.draws.create!(name: 'Draw 1') }

  example 'User A should create user draw' do
    post '/user_draws', params: { user_draw: { user_id: user_two.id, draw_id: draw.id, role: 'participant' } },
                        headers: user_one_auth_headers
    json_body = JSON.parse(response.body)
    expect(response).to have_http_status(:created)
    expect(json_body).not_to be_nil
  end

  example 'User A should destroy User B user draw' do
    user_draw = draw.add_participant!(user_two)
    delete "/user_draws/#{user_draw.id}", headers: user_one_auth_headers
    expect(response).to have_http_status(:no_content)
  end

  example 'User B should destroy self user draw' do
    user_draw = draw.add_participant!(user_two)
    delete "/user_draws/#{user_draw.id}", headers: user_two_auth_headers
    expect(response).to have_http_status(:no_content)
  end

  example 'Hihi should not destroy User B user draw' do
    user_draw = draw.add_participant!(user_two)
    expect do
      delete "/user_draws/#{user_draw.id}", headers: hihi_auth_headers
    end.to raise_error(Pundit::NotAuthorizedError)
  end
end
