muzang
======

Super simple IRCbot with **plugins**

[![BuildStatus](http://travis-ci.org/LTe/muzang.png)](http://github.com/LTe/muzang)

Create bot instance
===================

```
mkdir muzang-instance
cd muzang-instance
bundle init
```

### Edit Gemfile

```ruby
source "http://rubygems.org"

gem 'muzang'
```

### Template

```ruby
# muzang.rb
require 'muzang'

EM.run do
  @bot = Muzang::Bot.new(irc_host:  'localhost',
                         irc_port:  6667,
                         nick:      'muzang',
                         channels:  ['#test'])
  @bot.register_plugin(PluginClass)
  @bot.start # start after register plugins  
end
```

### Run

```
bundle exec ruby muzang.rb
```


How to create plugin?
=====================

```ruby
class PluginName
  def initialize(bot)
    # initialize stuff
  end

  def call(connection, *message)
    # plugin stuff
  end
end
```

## Connection

def call(**connection**, message)

### Methods of connection object
* *join(channel)* **join to channel**
* *part(channel)* **exit from the channel**
* *msg(channel, text)* **send message to channel or to user**

## Message

def call(connection, **message**)

### Methods of message object
* numeric_reply
* *nick* **who sent the message**
* user
* host
* *sever* **server from which the message was sent**
* error
* *channel* **channel from which the message was sent**
* *message* **message body**
* *command* **message command**

## Plugins

[muzang-plugins](http://github.com/LTe/muzang-plugins)


Contributing to muzang
========================
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

Copyright
=========

Copyright (c) 2011 Piotr Niełacny. See LICENSE.txt for
further details.

