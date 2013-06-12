# LeapauthHelper

Helps you to authenticate against Leap Motion Central.

## Guide 

### Install

Add to your Gemfile:

    gem 'leapauth_helper', '~> 1.0.0'

Then execute:

    $ bundle

Then Change your secret_token.rb to match the others.

### Usage

```
class ApplicationController < ActionController::Base
  include LeapauthHelper
  before_filter :authenticate_auth_user

  def current_user
    current_user_from_auth  # or keep your own User model
  end
  ...
end
```

#### Url Generators

In your app, you should use the following methods to generate the URLs that you need that talk with Central (the auth system).
    
* `auth_get_user_id_json_url`
* `auth_create_session_json_url`
* `auth_update_user_json_url(user_id)`
* `auth_sign_in_url(destination = current_url)` (alias `auth_create_session_url`)
* `auth_sign_out_url(destination = current_url)` (alias `auth_destroy_session_url`)
* `auth_forgot_password_url`
* `auth_require_username_url`
* `auth_edit_profile_url`
* `auth_revert_to_admin_url`
* `auth_admin_users_url`
* `auth_admin_user_url(user_id)`
* `auth_admin_user_edit_embed_url(user_id)`

#### Mixpanel Helpers

Where you want to use Mixpanel, you'll need to instatiate a Mixpanel helper.

To make things available, add this to your ApplicationController:

```ruby
class ApplicationController

  ...

  before_filter :initialize_mixpanel

  def initialize_mixpanel
    @mixpanel ||= Mixpanel.new(site_name, current_user)
  end

  ...
end
```

where `site_name` should be the value used for "Site" in the mixpanel event tracking.

Then in your views, you'll need to render the Mixpanel initialization:

```erb
<!-- in application.erb - maybe in the HEAD section -->
<%= @mixpanel.render_init %>
```

To track links and forms:

```erb
<%= @mixpanel.track_form('.form-selector',      'The form to track', { my_param: 'my value'}) %>
<%= @mixpanel.track_link('a.my-trackable-link', 'The link to track', { my_param: 'my value'}) %>
```

To track links and forms with callback methods instead of hashes:

```erb
<%= @mixpanel.track_form_with_callback('.form-selector', 'The form to track', "function(f) { return {form_name: $(f).name} }") %>
<%= @mixpanel.track_link_with_callback( ... ) %>
```

Read the mixpanel API docs for more about callbacks with the `track_link`/`track_form` methods.

To track events that may happen in controllers (calling mixpanel.track), register the events before the end of the rendered `<body>`:

* In controller methods:

```ruby
@mixpanel.track 'my event'
@mixpanel.track 'my event with opts', { :opt1 => 'value 1' }
```

* In a view:

```erb
<%=
    @mixpanel.track 'my event'
    @mixpanel.track 'my event with opts', { :opt1 => 'value 1' }
%>
```

At the end of the `<body>`, call `render_events`:

```erb
<%= @mixpanel.render_events %>
```

TaDa!

#### Google Analytics Helper

All Leap Motion properties use the same Google Analytics property ID and in fact the exact same tracking script. Everything is already baked into this gem
and properly configured to only call GA in production environments, so integration is literally one line:

`<%= LeapauthHelper::GoogleAnalytics.render_init() %>`

Put that one line into the `<head>` of your base application layout, and you're done!

#### Version >= 1.1.0

With version 1.1.0 we deprecated the `secure_url` method.  You should be able to upgrade without issues, but you'll get deprecation warning messages.

There are now pair methods for sign in/sign out.

`auth_create_session_url` and `auth_destroy_session_url`
`auth_sign_in_url` and `auth_sign_out_url`

#### Version >= 1.0.0

Configuration should happen with an initializer in your config/initializers folder like 
`config/initializers/leapauth_helper.rb`.  In there, you can set configuration params as necessary like this:

    LeapauthHelper.configure do |cfg|
      cfg.auth_host = 'this.host.com'
      cfg.home = 'this.apps.domain.name'
    end

Available configuration params are:

- `auth_host`
- `auth_domain`
- `home`
- `cookie_auth_key`
- `transactions_host`
- `uservoice_subdomain`
- `uservoice_sso_key`
- `mixpanel_token`
- `google_property_id`

The gem provides default values for all params in all environments except the Google Analytics property ID; in most cases, the default values should be fine.
Beyond that, the most common connection point you may want to change is the `auth_host` as that represents the pointer to the authentication domain (i.e., Central).

By default, Google Analytics is configured to only render in production environments. You can add IDs for non-production environments in the same way
as any other config param for LeapauthHelper.

#### Version < 1.0.0
 
Before version 1.0.0,  you could configure LeapauthHelper using environment variables.


### Halp

Then, make sure all your apps are on the same domain. For example, this should work:

1. leapweb - local.leapmotion:3000

2. leapdev - local.leapmotion:4000

3. cert - local.leapmotion:5000

But this won't work:

4. cert - localhost:5000
