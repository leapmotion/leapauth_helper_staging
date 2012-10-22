module LeapauthHelper
  module UserCapabilities
  def capabilities
    @capabilities ||= begin
      cap = []
      cap << 'blog_writer' if respond_to?(:blog_writer?) && blog_writer?
      cap << 'dev_access' if respond_to?(:dev_terms?) && dev_terms?
      cap << 'employee' if respond_to?(:email) && email[/@leapmotion.com$/]
      cap << 'admin' if respond_to?(:admin?) && admin?
      cap
    end
  end
  end
end