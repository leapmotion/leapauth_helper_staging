class CookieJar < Hash
  def delete(key, args={})
    super(key) if fetch(key)[:domain] == args[:domain]
  end

  def [](key)
    hash = super(key)
    return nil if hash.nil?

    cookie = Cookie.new(hash[:value])
    cookie.data = hash
    cookie
  end

  def signed
    self
  end
end

class Cookie < String
  def data=(data)
    @data = data
  end

  def [](key)
    @data[key]
  end
end

module Test
  module CookieHelper
    attr_reader :cookie_jar
    def stub_cookies!
      @cookie_jar = CookieJar.new
      stub(:cookies => @cookie_jar)
    end
  end
end
