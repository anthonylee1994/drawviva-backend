require 'rails_helper'

RSpec.describe 'DrawItems', type: :request do
  let(:user_one) { User.create!(email: 'user@example.com', display_name: 'User A') }
  let(:user_one_auth_headers) { { 'Authorization': "Bearer #{user_one.token}" } }
  let(:user_two) { User.create!(email: 'otheruser@gmail.com', display_name: 'User B') }
  let(:user_two_auth_headers) { { 'Authorization': "Bearer #{user_two.token}" } }
  let(:draw) { user_one.draws.create!(name: 'Draw 1') }

  example 'User A should draw' do
    draw.draw_items.create!(name: 'Item 1')
    draw.draw_items.create!(name: 'Item 2')
    draw.draw_items.create!(name: 'Item 3')

    post "/draws/#{draw.id}/draw", headers: user_one_auth_headers
    expect(response).to have_http_status(:ok)
    json_body = JSON.parse(response.body)
    expect(json_body).not_to be_empty
  end

  example 'User A should create draw item' do
    post "/draws/#{draw.id}/draw_items",
         params: { draw_item: { name: 'Name' } },
         headers: user_one_auth_headers

    expect(response).to have_http_status(:created)
    json_body = JSON.parse(response.body)
    expect(json_body['name']).to eq('Name')
  end

  example 'User B should not create draw item' do
    draw.add_participant!(user_two)

    expect do
      post "/draws/#{draw.id}/draw_items",
           params: { draw_item: { name: 'Name' } },
           headers: user_two_auth_headers
    end.to raise_error(Pundit::NotAuthorizedError)
  end

  example 'User A should update draw item' do
    draw_item = draw.draw_items.create!(name: 'Name')
    put "/draw_items/#{draw_item.id}",
        params: { draw_item: { name: 'New Name' } },
        headers: user_one_auth_headers

    expect(response).to have_http_status(:ok)
    json_body = JSON.parse(response.body)
    expect(json_body['name']).to eq('New Name')
  end

  example 'User A should destroy draw item' do
    draw_item = draw.draw_items.create!(name: 'Name')
    delete "/draw_items/#{draw_item.id}",
           headers: user_one_auth_headers

    expect(response).to have_http_status(:no_content)
  end
end
