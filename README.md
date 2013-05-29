# LeapauthHelper

Helps you with authing with leapweb.

do the single sign on dance.

## Guide 

### Install

add to your Gemfile:

    gem 'leapauth_helper'

then execute:

    $ bundle

change your secret_token.rb to match the others.

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

#### Version > 1.0.0

Configuration should happen with an initializer in your config/initializers folder like 
`config/initializers/leapauth_helper.rb`.  In there, you can set configuration params as necessary like this:

    LeapauthHelper.configure do |cfg|
      cfg.auth_host = 'this.host.com'
      cfg.home = 'this.apps.domain.name'
    end

Available configuration params are `auth_host`, `auth_domain`, `home`, `cookie_auth_key` and `transactions_host`.  In most cases, the default values should be fine.  Beyond that, the most common connection point you may want to change is the `auth_host` as that represents the pointer to the authentication domain (i.e. Central) represents the pointer to the authentication domain (i.e. Central).

### Halp

Make sure you're on the same domain.

for example, this should work:

1. leapweb - local.leapmotion:3000

2. leapdev - local.leapmotion:4000

3. cert - local.leapmotion:5000

this won't work

3. cert - localhost:5000
