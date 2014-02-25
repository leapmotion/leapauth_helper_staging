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

      return string.html_safe
    end

    #
    # Renders a Google Analytics virtual link track-ready javascript to
    # ensure the click is registered as a GA page view.
    #
    # NOTE: Virtual page view plumbing ws originally setup within
    # Google Tag manager, which enables us to use the sendVirtualPageView
    # GA event.
    #
    # @param  selector  The selector to use for the link (i.e. '#about_link')
    # @param  page_url  Page url to track (i.e. '/apps/purchase')
    #
    def self.track_link(selector, page_url)
      string = <<-EOS
        <script type="text/javascript">
      EOS

      string += <<-EOS
          if ($('#{selector}').length > 0) {
            $('#{selector}').click(function() {
              if (dataLayer) {
                dataLayer.push({
                  'event':'sendVirtualPageView',
                  'virtualUrl': '#{page_url}'
                });
              }
            }
          }
        </script>
      EOS

      return string.html_safe
    end
  end
end
