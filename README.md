drug-bot
========

IRC bot for #drug.pl channel

Plugin
======

```ruby
class PluginName
  def initialize(bot)
  end

  def call(connection, message)
  end
end
```

*connection* - you can use methods from Coffeemaker::Commands

message

```ruby
# example message
  {
    :command => "PRIVMSG",
    :user    => "LTe",
    :nick    => "LTe",
    :host    => "localhost",
    :message => "Hi there!",
    :channel => "#test"
  }
```

After that just execute .register_plugin before bot start

```ruby
  @bot = DrugBot::Bot.new
  @bot.register_plugin(PluginName)
  @bot.start
```

== Contributing to drug-bot
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

== Copyright

Copyright (c) 2011 Piotr Niełacny. See LICENSE.txt for
further details.

