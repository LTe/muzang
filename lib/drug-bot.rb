require 'rubygems'
require 'bundler/setup'
Bundler.require # require libs

require 'drug-bot/irc'
require 'drug-bot/drug-bot'
require 'drug-bot/helpers'
require 'drug-bot/version'

autoload :Eval,         'drug-bot/plugins/eval'
autoload :LiveReload,   'drug-bot/plugins/livereload'
autoload :Motd,         'drug-bot/plugins/motd'
autoload :NerdPursuit,  'drug-bot/plugins/nerdpursuit'
autoload :Reddit,       'drug-bot/plugins/reddit'
autoload :PlusOne,      'drug-bot/plugins/plusone'
autoload :RubyGems,     'drug-bot/plugins/rubygems'
