# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Draws', type: :request do
  let(:anthony) { User.create!(email: 'hososlch@gmail.com', display_name: 'Anthony') }
  let(:ken) { User.create!(email: 'kencckw@gmail.com', display_name: 'Ken') }
  let(:anthony_auth_headers) { { 'Authorization': "Bearer #{anthony.token}" } }
  let(:ken_auth_headers) { { 'Authorization': "Bearer #{ken.token}" } }
  let(:draw) { anthony.draws.create!(name: 'Draw 1') }

  example 'anthony should list draw' do
    draw
    get '/draws', headers: anthony_auth_headers
    expect(response).to have_http_status(:ok)
    json_body = JSON.parse(response.body)
    expect(json_body.first['id']).to eq(draw.id)
    expect(json_body.first['name']).to eq(draw.name)
  end

  example 'anthony should create draw' do
    post '/draws', params: { draw: { name: 'Draw 1' } }, headers: anthony_auth_headers
    expect(response).to have_http_status(:created)
    json_body = JSON.parse(response.body)
    expect(json_body['name']).to eq('Draw 1')
    last_draw = Draw.last
    expect(anthony.draws).to eq [last_draw]
    expect(last_draw.users).to eq [anthony]
    expect(last_draw.admins).to eq [anthony]
    expect(last_draw.participants).to eq []
  end

  example 'anthony should update draw' do
    put "/draws/#{draw.id}", params: { draw: { name: 'Hello' } }, headers: anthony_auth_headers
    expect(response).to have_http_status(:no_content)
    expect(draw.reload.name).to eq('Hello')
  end

  example 'keb should not update draw' do
    expect do
      draw.add_participant!(ken)
      put "/draws/#{draw.id}", params: { draw: { name: 'Hello' } }, headers: ken_auth_headers
    end.to raise_error( Pundit::NotAuthorizedError)
  end

  example 'keb should update draw, after anthony quit' do
    draw.add_participant!(ken)
    draw.kick_user!(anthony)
    put "/draws/#{draw.id}", params: { draw: { name: 'Hello' } }, headers: ken_auth_headers
    expect(response).to have_http_status(:no_content)
    expect(draw.reload.name).to eq('Hello')
  end

  example 'anthony should destroy draw' do
    delete "/draws/#{draw.id}", headers: anthony_auth_headers
    expect(response).to have_http_status(:no_content)
    expect(Draw.count).to eq(0)
  end
end
