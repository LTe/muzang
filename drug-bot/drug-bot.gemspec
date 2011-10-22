# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "drug-bot/version"

Gem::Specification.new do |s|
  s.name        = "drug-bot"
  s.version     = DrugBot::VERSION
  s.authors     = ["Piotr Niełacny"]
  s.email       = ["piotr.nielacny@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Dolnoslaska Ruby User Group IRC bot}
  s.description = %q{IRC bot with easy plugin managment}

  s.rubyforge_project = "drug-bot"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency "eventmachine", "~> 0.12.10"
  s.add_runtime_dependency "em-http-request", "~> 0.3.0"
end
