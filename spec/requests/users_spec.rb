require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let(:anthony) { User.create!(email: 'hososlch@gmail.com', display_name: 'Anthony') }

  example 'list users' do
    anthony
    get '/users', headers: { Authorization: "Bearer #{anthony.token}" }
    json_body = JSON.parse(response.body)
    expect(json_body.count).to eq(1)
  end

  example 'get me' do
    get '/me', headers: { Authorization: "Bearer #{anthony.token}" }
    json_body = JSON.parse(response.body)

    expect(json_body['display_name']).to eq 'Anthony'
    expect(json_body['email']).to eq 'hososlch@gmail.com'
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
      Authorization: "Bearer #{anthony.token}"
    }
    expect(response).to have_http_status(:no_content)
    anthony.push_notification_subscription.reload
    expect(anthony.push_notification_subscription.auth).to eq 'auth'
    expect(anthony.push_notification_subscription.p256dh).to eq 'p256dh'
  end
end
