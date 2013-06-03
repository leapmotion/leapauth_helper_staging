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

The gem provides default values for all params; in most cases, the default values should be fine.
Beyond that, the most common connection point you may want to change is the `auth_host` as that represents the pointer to the authentication domain (i.e., Central).

#### Version < 1.0.0
 
Before version 1.0.0,  you could configure LeapauthHelper using environment variables.


### Halp

Then, make sure all your apps are on the same domain. For example, this should work:

1. leapweb - local.leapmotion:3000

2. leapdev - local.leapmotion:4000

3. cert - local.leapmotion:5000

But this won't work:

4. cert - localhost:5000
