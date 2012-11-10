module LeapauthHelper
  module UserCapabilities
    Flags = [ :super_admin, :admin, :representative, :preorder_admin, :developer ]
    EmployeeFlags = [ :super_admin, :admin, :representative, :preorder_admin ]

    def capabilities
      @capabilities ||= begin
        cap = []
        cap << 'blog_writer' if respond_to?(:blog_writer?) && blog_writer?
        cap << 'dev_access' if respond_to?(:is_developer?) && respond_to?(:dev_terms) && is_developer? && dev_terms?
        cap << 'employee' if respond_to?(:lm) && lm?
        cap << 'admin' if respond_to?(:is_admin?) && is_admin?
        cap
      end
    end
  end
end