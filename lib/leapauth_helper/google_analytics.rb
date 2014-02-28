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
    # NOTE: Virtual page view plumbing was originally setup within
    # Google Tag manager, which enables us to use the sendVirtualPageView
    # GA event.
    #
    # Example usage:
    #
    # // HTML Link
    # <%= link_to "ABOUT US", company_url, :id => "about" %>
    #
    # // Generates link click handler javascript and GA pageview track on-click.
    # <%= LeapauthHelper::GoogleAnalytics::track_link('#about', 'links/about/click') %>
    #
    # @param  selector  The selector to use for the link (i.e. '#about_link')
    # @param  page_url  Page url to track (i.e. '/apps/purchase')
    # @param  callback  (Optional) String-based Javascript method for invoking and creating additional
    #                   parameters to append to page_url, i.e. 'AnalyticsHelper.extract_title' may return
    #                   'my_footer_link', which can them be appened as /nav/click/my_footer_link.
    #
    def self.track_link(selector, page_url, callback=nil)
      string = <<-EOS
        <script type="text/javascript">
      EOS

      string += <<-EOS
          $('#{selector}').click(function() {
            var extra_params = '';
            if ('#{callback}' != '') {
              extra_params = '/' + eval('#{callback}'+'($(this));');
            }

            if (dataLayer) {
              dataLayer.push({
                'event':'sendVirtualPageView',
                'virtualUrl': '#{page_url}' + extra_params
              });
            }
          });
        </script>
      EOS

      return string.html_safe
    end
  end
end
