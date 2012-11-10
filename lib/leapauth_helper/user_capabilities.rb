module LeapauthHelper
  module UserCapabilities
    Flags = [ :is_super_admin, :is_admin, :is_representative, :is_preorder_admin, :is_lm, :is_developer ]
    EmployeeFlags = [ :is_super_admin, :is_admin, :is_representative, :is_preorder_admin, :is_lm ]

    def capabilities
      @capabilities ||= begin
        cap = []
        cap << 'dev_access' if respond_to?(:is_developer?) && respond_to?(:dev_terms) && is_developer? && dev_terms?
        cap << 'employee' if respond_to?(:is_lm) && is_lm?
        cap << 'admin' if respond_to?(:is_admin?) && is_admin?
        cap
      end
    end
  end
end