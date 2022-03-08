# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'UserDraws', type: :request do
  let(:anthony) { User.create!(email: 'hososlch@gmail.com', display_name: 'Anthony') }
  let(:anthony_auth_headers) { { 'Authorization': "Bearer #{anthony.token}" } }
  let(:ken) { User.create!(email: 'kencckw@gmail.com', display_name: 'Ken') }
  let(:ken_auth_headers) { { 'Authorization': "Bearer #{ken.token}" } }
  let(:hihi) { User.create!(email: 'hihi@gmail.com', display_name: 'Hihi') }
  let(:hihi_auth_headers) { { 'Authorization': "Bearer #{hihi.token}" } }
  let(:draw) { anthony.draws.create!(name: 'Draw 1') }

  example 'Anthony should create user draw' do
    post '/user_draws', params: { user_draw: { user_id: ken.id, draw_id: draw.id, role: 'participant' } },
                        headers: anthony_auth_headers
    json_body = JSON.parse(response.body)
    expect(response).to have_http_status(:created)
    expect(json_body).not_to be_nil
  end

  example 'Anthony should destroy Ken user draw' do
    user_draw = draw.add_participant!(ken)
    delete "/user_draws/#{user_draw.id}", headers: anthony_auth_headers
    expect(response).to have_http_status(:no_content)
  end

  example 'Ken should destroy self user draw' do
    user_draw = draw.add_participant!(ken)
    delete "/user_draws/#{user_draw.id}", headers: ken_auth_headers
    expect(response).to have_http_status(:no_content)
  end

  example 'Hihi should not destroy Ken user draw' do
    user_draw = draw.add_participant!(ken)
    expect do
      delete "/user_draws/#{user_draw.id}", headers: hihi_auth_headers
    end.to raise_error(Pundit::NotAuthorizedError)
  end
end
