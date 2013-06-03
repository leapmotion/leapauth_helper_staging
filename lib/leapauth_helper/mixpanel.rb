module LeapauthHelper
  module Mixpanel
    #-----------------------------------------------------------------------------------------------

    def mixpanel_init(site_name)
      string = '<script type="text/javascript">'

      # MixPanel SDK
      string += <<-EOS
        (function(e,b){if(!b.__SV){var a,f,i,g;window.mixpanel=b;a=e.createElement("script");a.type="text/javascript";a.async=!0;a.src=("https:"===e.location.protocol?"https:":"http:")+'//cdn.mxpnl.com/libs/mixpanel-2.2.min.js';f=e.getElementsByTagName("script")[0];f.parentNode.insertBefore(a,f);b._i=[];b.init=function(a,e,d){function f(b,h){var a=h.split(".");2==a.length&&(b=b[a[0]],h=a[1]);b[h]=function(){b.push([h].concat(Array.prototype.slice.call(arguments,0)))}}var c=b;"undefined"!==typeof d?c=b[d]=[]:d="mixpanel";c.people=c.people||[];c.toString=function(b){var a="mixpanel";"mixpanel"!==d&&(a+="."+d);b||(a+=" (stub)");return a};c.people.toString=function(){return c.toString(1)+".people (stub)"};i="disable track track_pageview track_links track_forms register register_once alias unregister identify name_tag set_config people.set people.increment people.append people.track_charge people.clear_charges people.delete_user".split(" ");for(g=0;g<i.length;g++)f(c,i[g]);b._i.push([a,e,d])};b.__SV=1.2}})(document,window.mixpanel||[]);
      EOS

      # single MixPanel token for all LeapMotion projects
      string += "mixpanel.init('#{LeapauthHelper.config.mixpanel_token}');"

      # each site identifies with this arg
      string += "mixpanel.register({ Site: '#{site_name}' });"

      # set some super-properties if we have a user object
      if defined?(current_user) && !current_user.nil?

        if current_user.respond_to?(:email) && !current_user.email.nil? && !current_user.email.empty?
          string += "mixpanel.name_tag('#{current_user.email}');"
        end

        if current_user.respond_to?(:sign_in_count)
          string += "mixpanel.register({ 'First Launch': #{current_user.sign_in_count.to_i <= 1} });"
        end

      end

      string += "</script>"

      @leapauth_helper_mixpanel_events ||= []

      return string.html_safe
    end

    #-----------------------------------------------------------------------------------------------

    def mixpanel_render
      string = '<script type="text/javascript">'

      @leapauth_helper_mixpanel_events ||= []
      @leapauth_helper_mixpanel_events.each do |e|
        e[1] ||= {}
        string += "mixpanel.track('#{e[0]}', #{JSON.generate(e[1]).html_safe});"
      end

      string += "</script>"
      return string.html_safe
    end

    #-----------------------------------------------------------------------------------------------

    def mixpanel_track(event, opts = {})
      @leapauth_helper_mixpanel_events ||= []
      @leapauth_helper_mixpanel_events << [event, opts]
    end

    #-----------------------------------------------------------------------------------------------

    def mixpanel_track_link(selector, event, opts = {})
      string = '<script type="text/javascript">'
      string += "mixpanel.track_links('#{selector}', '#{event}', #{JSON.generate(opts).html_safe});"
      string += "</script>"
      return string.html_safe
    end

    #-----------------------------------------------------------------------------------------------
  end
end
