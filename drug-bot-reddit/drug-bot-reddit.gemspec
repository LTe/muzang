# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "drug-bot-reddit/version"

Gem::Specification.new do |s|
  s.name        = "drug-bot-reddit"
  s.version     = Reddit::VERSION
  s.authors     = ["Piotr Niełacny"]
  s.email       = ["piotr.nielacny@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Reddit plugin for DRUG-bot}
  s.description = %q{Fetch reddit .rss and send message to IRC channel}

  s.rubyforge_project = "drug-bot-reddit"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency "drug-bot", "~> 0.0.1"
end