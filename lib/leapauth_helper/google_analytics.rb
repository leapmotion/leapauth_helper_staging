module LeapauthHelper
  class GoogleAnalytics
    def self.render_init
      return "" unless LeapauthHelper.config.google_property_id.present?

      string = <<-EOS
        <script type="text/javascript">
          var _gaq = _gaq || [];
      EOS

      string += "_gaq.push(['_setAccount',    '#{LeapauthHelper.config.google_property_id}']);"
      string += "_gaq.push(['_setDomainName', 'leapmotion.com']);"

      string += <<-EOS
          _gaq.push(['_trackPageview']);

          (function() {
            var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
            ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
            var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
          })();
        </script>
      EOS

      return string
    end
  end
end
