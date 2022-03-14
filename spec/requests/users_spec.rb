require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let(:user_one) { User.create!(email: 'user@example.com', display_name: 'User A') }

  example 'list users' do
    user_one
    get '/users', headers: { Authorization: "Bearer #{user_one.token}" }
    json_body = JSON.parse(response.body)
    expect(json_body.count).to eq(1)
  end

  example 'get me' do
    get '/me', headers: { Authorization: "Bearer #{user_one.token}" }
    json_body = JSON.parse(response.body)

    expect(json_body['display_name']).to eq 'User A'
    expect(json_body['email']).to eq 'user@example.com'
    expect(json_body['push_notification_subscription']).not_to be_nil
  end

  example 'update me' do
    put '/me', params: {
      user: {
        push_notification_subscription_attributes: {
          auth: 'auth',
          endpoint: 'endpoint',
          p256dh: 'p256dh'
        }
      }
    }, headers: {
      Authorization: "Bearer #{user_one.token}"
    }
    expect(response).to have_http_status(:no_content)
    user_one.push_notification_subscription.reload
    expect(user_one.push_notification_subscription.auth).to eq 'auth'
    expect(user_one.push_notification_subscription.p256dh).to eq 'p256dh'
  end
end
