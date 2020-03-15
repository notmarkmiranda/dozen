class JsonWebToken
  SECRET_KEY = Rails.application.credentials.secret_key_base
  
  def self.encode(payload)
    JWT.encode(payload, SECRET_KEY)
  end

  def self.decode(token)
    decoded = JWT.decode(token, SECRET_KEY)[0]
    return HashWithIndifferentAccess.new(decoded)
  rescue
    nil
  end
end