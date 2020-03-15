class JsonWebToken
  def self.encode(payload)
    JWT.encode(payload, Rails.application.secrets.secret_key_base)
  end

  def self.decode(token)
    decoded = JWT.decode(token, Rails.application.secrets.secret_key_base)[0]
    return HashWithIndifferentAccess.new(decoded)
  rescue
    nil
  end
end