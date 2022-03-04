class JwtService
  def self.encode(payload)
    JWT.encode payload, Settings.auth.hmac_secret, 'HS256'
  end

  def self.decode(token)
    (JWT.decode token, Settings.auth.hmac_secret, true, { algorithm: 'HS256' }).first
  end
end
