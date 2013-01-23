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

### Halp

Make sure you're on the same domain.

for example, this should work:

1. leapweb - local.leapmotion:3000

2. leapdev - local.leapmotion:4000

3. cert - local.leapmotion:5000

this won't work

3. cert - localhost:5000
