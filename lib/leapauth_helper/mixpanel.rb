module LeapauthHelper
  class Mixpanel
    #-----------------------------------------------------------------------------------------------

    def initialize(site_name, current_user = nil)
      @site_name = site_name
      @current_user = current_user
      @leapauth_helper_mixpanel_events = []
    end

    #-----------------------------------------------------------------------------------------------

    def render_init
      string = '<script type="text/javascript">'

      # MixPanel SDK
      string += <<-EOS
        (function(e,b){if(!b.__SV){var a,f,i,g;window.mixpanel=b;a=e.createElement("script");a.type="text/javascript";a.async=!0;a.src=("https:"===e.location.protocol?"https:":"http:")+'//cdn.mxpnl.com/libs/mixpanel-2.2.min.js';f=e.getElementsByTagName("script")[0];f.parentNode.insertBefore(a,f);b._i=[];b.init=function(a,e,d){function f(b,h){var a=h.split(".");2==a.length&&(b=b[a[0]],h=a[1]);b[h]=function(){b.push([h].concat(Array.prototype.slice.call(arguments,0)))}}var c=b;"undefined"!==typeof d?c=b[d]=[]:d="mixpanel";c.people=c.people||[];c.toString=function(b){var a="mixpanel";"mixpanel"!==d&&(a+="."+d);b||(a+=" (stub)");return a};c.people.toString=function(){return c.toString(1)+".people (stub)"};i="disable track track_pageview track_links track_forms register register_once alias unregister identify name_tag set_config people.set people.increment people.append people.track_charge people.clear_charges people.delete_user".split(" ");for(g=0;g<i.length;g++)f(c,i[g]);b._i.push([a,e,d])};b.__SV=1.2}})(document,window.mixpanel||[]);
      EOS

      # single MixPanel token for all LeapMotion projects
      string += "mixpanel.init('#{LeapauthHelper.config.mixpanel_token}');"

      # set up MixPanel config options
      config_options = { :debug => !(Internal.environment == "production") }
      string += "mixpanel.set_config(#{JSON.generate(config_options)});"

      # each site identifies with this arg
      string += "mixpanel.register({ Site: '#{@site_name}' });"

      # set some super-properties if we have a user object
      unless @current_user.nil?

        if @current_user.respond_to?(:email) && !@current_user.email.nil? && !@current_user.email.empty?
          string += "mixpanel.identify('#{@current_user.email}');"
          string += "mixpanel.name_tag('#{@current_user.email}');"
          string += "mixpanel.people.set({ $email: '#{@current_user.email}' });"
        end

        if @current_user.respond_to?(:sign_in_count)
          string += "mixpanel.register({ 'First Launch': #{@current_user.sign_in_count.to_i <= 1} });"
        end

        if @current_user.respond_to?(:is_developer?)
          string +=   "mixpanel.register({ is_developer: '#{@current_user.is_developer?}' });"
          string += "mixpanel.people.set({ is_developer: '#{@current_user.is_developer?}' });"
        end

        if @current_user.respond_to?(:username) && !@current_user.username.nil? && !@current_user.username.empty?
          string += "mixpanel.people.set({ $username: '#{@current_user.username}' });"
        end

        if @current_user.respond_to?(:created_at) && !@current_user.created_at.nil? && @current_user.created_at.respond_to?(:to_i)
          string += "mixpanel.people.set({ $created: new Date(#{@current_user.created_at.to_i * 1000}) });"
        end

      end

      string += "</script>"

      return string.html_safe
    end

    #-----------------------------------------------------------------------------------------------

    def render_events
      string = '<script type="text/javascript">'

      @leapauth_helper_mixpanel_events ||= []
      @leapauth_helper_mixpanel_events.each do |e|
        if !e[1].nil? && !e[1].empty? # empty hash blows JSON.generate
          string += "mixpanel.track('#{e[0]}', #{JSON.generate(e[1]).html_safe});"
        else
          string += "mixpanel.track('#{e[0]}');"
        end
      end

      string += "</script>"
      return string.html_safe
    end

    #-----------------------------------------------------------------------------------------------

    def track(event, opts = {})
      @leapauth_helper_mixpanel_events ||= []
      @leapauth_helper_mixpanel_events << [event, opts]
    end

    #-----------------------------------------------------------------------------------------------

    def track_link(selector, event, opts = {})
      opts_string = JSON.generate(opts).html_safe if !opts.nil? && !opts.empty?
      render_track_it_tag(:track_links, selector, event, opts_string)
    end

    #-----------------------------------------------------------------------------------------------

    def track_link_with_callback(selector, event, callback)
      render_track_it_tag(:track_links, selector, event, callback)
    end

    #-----------------------------------------------------------------------------------------------

    def track_form(selector, event, opts = {})
      opts_string = JSON.generate(opts).html_safe if !opts.nil? && !opts.empty?
      render_track_it_tag(:track_forms, selector, event, opts_string)
    end

    #-----------------------------------------------------------------------------------------------

    def track_form_with_callback(selector, event, callback)
      render_track_it_tag(:track_forms, selector, event, callback)
    end

    #-----------------------------------------------------------------------------------------------

    private
    def render_track_it_tag(mixpanel_method, selector, event, opts_string = nil)
      string = '<script type="text/javascript">'
      string += "mixpanel.#{mixpanel_method}('#{selector}', '#{event}'"
      if !opts_string.nil? && !opts_string.empty?
        string += ", #{opts_string}"
      end
      string += ");"
      string += "</script>"
      string.html_safe
    end
  end
end
