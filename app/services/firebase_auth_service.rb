# frozen_string_literal: true

class FirebaseAuthService
  class InvalidToken < StandardError; end

  def self.verify!(token)
    if Rails.env.test?
      raise InvalidToken if token != 'token'

      return { 'kind' => 'identitytoolkit#GetAccountInfoResponse',
               'users' =>
                 [{ 'localId' => 'localId',
                    'email' => 'user@example.com',
                    'displayName' => 'User',
                    'photoUrl' => 'photoUrl',
                    'emailVerified' => true,
                    'providerUserInfo' =>
                      [{ 'providerId' => 'google.com',
                         'displayName' => 'User',
                         'photoUrl' => 'photoUrl',
                         'federatedId' => '1234567890',
                         'email' => 'user@example.com',
                         'rawId' => '1234567890' }],
                    'validSince' => '1646301650',
                    'lastLoginAt' => '1646362625639',
                    'createdAt' => '1646301650310',
                    'lastRefreshAt' => '2022-03-04T02:57:05.639Z' }] }.deep_transform_keys! { |key| key.underscore.to_sym }
    end

    response = RestClient.post(
      "https://www.googleapis.com/identitytoolkit/v3/relyingparty/getAccountInfo?key=#{ENV['FIREBASE_API_KEY']}", 'idToken' => token
    )

    if response.code == 200
      JSON.parse(response.body).deep_transform_keys! { |key| key.underscore.to_sym }
    else
      raise InvalidToken
    end
  end
end
