module LeapauthHelper
  module UserCapabilities
    Flags = [ :is_super_admin, :is_admin, :is_representative, :is_preorder_admin, :is_developer ]
    EmployeeFlags = [ :is_super_admin, :is_admin, :is_representative, :is_preorder_admin ]

    def capabilities
      @capabilities ||= begin
        cap = []
        cap << 'dev_access' if respond_to?(:is_developer?) && respond_to?(:dev_terms) && is_developer? && dev_terms?
        cap << 'employee' if respond_to?(:lm) && lm?
        cap << 'admin' if respond_to?(:is_admin?) && is_admin?
        cap
      end
    end
  end
end