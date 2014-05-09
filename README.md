# Slack.rb

Ruby toolkit for working with the Slack API

[![Build Status](https://travis-ci.org/netflower/slack.rb.svg?branch=master)](https://travis-ci.org/netflower/slack.rb)
[![Code Climate](https://codeclimate.com/github/netflower/slack.rb.png)](https://codeclimate.com/github/netflower/slack.rb)
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
client = Slack::Client.new(team: 'netflower', token: 'xxxx-xxxxxxxxx-xxxx')
# Post a message
client.post_message("May the force be with you", "yoda-quotes")
# List all channels
client.channels
```

## Configuration and defaults

### Configuring module defaults

Every writable attribute in {Slack::Configurable} can be set one at a time:

```ruby
Slack.api_endpoint     = 'https://slack.dev/api'
Slack.default_channel  = '#lol-cats'
Slack.default_username = 'Yoda'
```

or in batch:

```ruby
Slack.configure do |c|
  c.api_endpoint     = 'https://slack.dev/api'
  c.default_channel  = '#lol-cats'
  c.default_username = 'Yoda'
end
```

### Using ENV variables

Default configuration values are specified in {Slack::Default}. Many
attributes will look for a default value from the ENV before returning
Slack's default.

```ruby
# Given $SLACK_API_ENDPOINT is "https://slack.dev/api"
Slack.api_endpoint

# => "https://slack.dev/api"
```

## Contributing

1. Fork it ( http://github.com/<my-github-username>/slack/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
