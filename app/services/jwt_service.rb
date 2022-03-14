class JwtService
  def self.encode(payload)
    JWT.encode payload, ENV['AUTH_HMAC_SECRET'], 'HS256'
  end

  def self.decode(token)
    (JWT.decode token, ENV['AUTH_HMAC_SECRET'], true, { algorithm: 'HS256' }).first
  end
end
