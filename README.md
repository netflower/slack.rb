# Slack.rb

Ruby toolkit for working with the Slack API

[![Build Status](https://travis-ci.org/netflower/slack.rb.svg?branch=master)](https://travis-ci.org/netflower/slack.rb)

## Installation

Add this line to your application's Gemfile:

    gem 'slack'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install slack

## Usage

### Making requests

```ruby
# Provide authentication credentials
client = Slack::Client.new('team', 'api_token')
# Post a message
client.post_message("May the force be with you", "yoda-quotes")
# List all channels
client.channels
```

## Contributing

1. Fork it ( http://github.com/<my-github-username>/slack/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
