module LeapauthHelper
  class AuthUser
    attr_reader :id, :email, :username, :expires_on

    def initialize(opts)
      @id = opts['id']
      @email = opts['email']
      @username = opts['username']
      @expires_on = opts['expires_on']
    end

    def expired?
      @expires_on.nil? or @expires_on < Time.now.utc.to_i
    end
  end
end
