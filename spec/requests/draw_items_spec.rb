require 'rails_helper'

RSpec.describe 'DrawItems', type: :request do
  let(:anthony) { User.create!(email: 'hososlch@gmail.com', display_name: 'Anthony') }
  let(:anthony_auth_headers) { { 'Authorization': "Bearer #{anthony.token}" } }
  let(:ken) { User.create!(email: 'kencckw@gmail.com', display_name: 'Ken') }
  let(:ken_auth_headers) { { 'Authorization': "Bearer #{ken.token}" } }
  let(:draw) { anthony.draws.create!(name: 'Draw 1') }

  example 'Anthony should draw' do
    draw.draw_items.create!(name: 'Item 1')
    draw.draw_items.create!(name: 'Item 2')
    draw.draw_items.create!(name: 'Item 3')

    post "/draws/#{draw.id}/draw", headers: anthony_auth_headers
    expect(response).to have_http_status(:ok)
    json_body = JSON.parse(response.body)
    expect(json_body).not_to be_empty
  end

  example 'Anthony should create draw item' do
    post "/draws/#{draw.id}/draw_items",
         params: { draw_item: { name: 'Name' } },
         headers: anthony_auth_headers

    expect(response).to have_http_status(:created)
    json_body = JSON.parse(response.body)
    expect(json_body['name']).to eq('Name')
  end

  example 'Ken should not create draw item' do
    draw.add_participant!(ken)

    expect do
      post "/draws/#{draw.id}/draw_items",
           params: { draw_item: { name: 'Name' } },
           headers: ken_auth_headers
    end.to raise_error(Pundit::NotAuthorizedError)
  end

  example 'Anthony should update draw item' do
    draw_item = draw.draw_items.create!(name: 'Name')
    put "/draw_items/#{draw_item.id}",
        params: { draw_item: { name: 'New Name' } },
        headers: anthony_auth_headers

    expect(response).to have_http_status(:ok)
    json_body = JSON.parse(response.body)
    expect(json_body['name']).to eq('New Name')
  end

  example 'Anthony should destroy draw item' do
    draw_item = draw.draw_items.create!(name: 'Name')
    delete "/draw_items/#{draw_item.id}",
           headers: anthony_auth_headers

    expect(response).to have_http_status(:no_content)
  end
end
