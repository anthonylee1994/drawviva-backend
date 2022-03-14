# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Draws', type: :request do
  let(:user_one) { User.create!(email: 'user@example.com', display_name: 'User A') }
  let(:user_two) { User.create!(email: 'otheruser@gmail.com', display_name: 'User B') }
  let(:user_one_auth_headers) { { 'Authorization': "Bearer #{user_one.token}" } }
  let(:user_two_auth_headers) { { 'Authorization': "Bearer #{user_two.token}" } }
  let(:draw) { user_one.draws.create!(name: 'Draw 1') }

  example 'User A should list draw' do
    draw.draw_items.create!(name: 'Item 1')
    draw.draw_items.create!(name: 'Item 2')
    draw.draw_items.create!(name: 'Item 3')
    get '/draws', headers: user_one_auth_headers
    expect(response).to have_http_status(:ok)
    json_body = JSON.parse(response.body)
    expect(json_body.first['id']).to eq(draw.id)
    expect(json_body.first['name']).to eq(draw.name)
    expect(json_body.first.dig('user_draw', 'role')).to eq('admin')
    expect(json_body.first['draw_items'].count).to eq(3)
  end

  example 'User A should create draw' do
    post '/draws', params: { draw: { name: 'Draw 1' } }, headers: user_one_auth_headers
    expect(response).to have_http_status(:created)
    json_body = JSON.parse(response.body)
    expect(json_body['name']).to eq('Draw 1')
    last_draw = Draw.last
    expect(user_one.draws).to eq [last_draw]
    expect(last_draw.users).to eq [user_one]
    expect(last_draw.admins).to eq [user_one]
    expect(last_draw.participants).to eq []
  end

  example 'User A should update draw' do
    put "/draws/#{draw.id}", params: { draw: { name: 'Hello' } }, headers: user_one_auth_headers
    expect(response).to have_http_status(:no_content)
    expect(draw.reload.name).to eq('Hello')
  end

  example 'User B should not update draw' do
    expect do
      draw.add_participant!(user_two)
      put "/draws/#{draw.id}", params: { draw: { name: 'Hello' } }, headers: user_two_auth_headers
    end.to raise_error(Pundit::NotAuthorizedError)
  end

  example 'User B should update draw, after user_one quit' do
    draw.add_participant!(user_two)
    draw.kick_user!(user_one)
    put "/draws/#{draw.id}", params: { draw: { name: 'Hello' } }, headers: user_two_auth_headers
    expect(response).to have_http_status(:no_content)
    expect(draw.reload.name).to eq('Hello')
  end

  example 'User A should destroy draw' do
    delete "/draws/#{draw.id}", headers: user_one_auth_headers
    expect(response).to have_http_status(:no_content)
    expect(Draw.count).to eq(0)
  end
end
