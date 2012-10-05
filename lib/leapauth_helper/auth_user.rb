module LeapauthHelper
  class AuthUser
    attr_reader :id, :email, :username

    def initialize(opts)
      @id = opts['id']
      @email = opts['email']
      @admin = opts['username']
    end
  end
end
