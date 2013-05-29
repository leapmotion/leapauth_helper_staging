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
#### Version < 1.0.0
 
Before version 1.0.0,  you could configure LeapauthHelper using environment variables.

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

### Halp

First, make sure you have your `RAILS_ENV` environment variable set (not just `RACK_ENV`).

Then, make sure all your apps are on the same domain. For example, this should work:

1. leapweb - local.leapmotion:3000

2. leapdev - local.leapmotion:4000

3. cert - local.leapmotion:5000

But this won't work:

4. cert - localhost:5000
