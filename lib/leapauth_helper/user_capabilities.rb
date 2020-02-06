module LeapauthHelper
  module UserCapabilities
    EmployeeFlags = [ :is_super_admin, :is_admin, :is_representative, :is_preorder_admin, :is_lm, :is_content_admin, :is_uservoice_admin, :is_privacy_admin ]
    Flags = EmployeeFlags + [ :is_developer, :is_beta, :is_media, :is_consumer_beta, :is_vip ]

    # This is currently used in LeapDev for Forem, and it may also be used elsewhere.
    # We should deprecate it in favor of CanCan someday though.
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
