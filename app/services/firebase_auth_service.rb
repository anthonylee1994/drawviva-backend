# frozen_string_literal: true

class FirebaseAuthService
  class InvalidToken < StandardError; end

  def self.verify!(token)
    if Rails.env.test?
      raise InvalidToken if token != 'token'

      return { 'kind' => 'identitytoolkit#GetAccountInfoResponse',
               'users' =>
                 [{ 'localId' => 'Igus3BSpFScsGepxRwmVHV53Qxy2',
                    'email' => 'hososlch@gmail.com',
                    'displayName' => 'Anthony Lee',
                    'photoUrl' => 'https://lh3.googleusercontent.com/a/AATXAJw8AfrjlDZ3mjs7kYjnj8NuJhErXBhKpmPM-lnzgQ=s96-c',
                    'emailVerified' => true,
                    'providerUserInfo' =>
                      [{ 'providerId' => 'google.com',
                         'displayName' => 'Anthony Lee',
                         'photoUrl' => 'https://lh3.googleusercontent.com/a/AATXAJw8AfrjlDZ3mjs7kYjnj8NuJhErXBhKpmPM-lnzgQ=s96-c',
                         'federatedId' => '108070242846057965350',
                         'email' => 'hososlch@gmail.com',
                         'rawId' => '108070242846057965350' }],
                    'validSince' => '1646301650',
                    'lastLoginAt' => '1646362625639',
                    'createdAt' => '1646301650310',
                    'lastRefreshAt' => '2022-03-04T02:57:05.639Z' }] }.deep_transform_keys! { |key| key.underscore.to_sym }
    end

    response = RestClient.post(
      "https://www.googleapis.com/identitytoolkit/v3/relyingparty/getAccountInfo?key=#{Settings.firebase.api_key}", 'idToken' => token
    )

    if response.code == 200
      JSON.parse(response.body).deep_transform_keys! { |key| key.underscore.to_sym }
    else
      raise InvalidToken
    end
  end
end
