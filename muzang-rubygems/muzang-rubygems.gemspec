# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "muzang-rubygems/version"

Gem::Specification.new do |s|
  s.name        = "muzang-rubygems"
  s.version     = Rubygems::VERSION
  s.authors     = ["Piotr Niełacny"]
  s.email       = ["piotr.nielacny@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Rubygems plugin for DRUG-bot}
  s.description = %q{Fetch all new gems from rubygems.org and send message to channel}

  s.rubyforge_project = "muzang-rubygems"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency "muzang", "~> 0.0.1"
  s.add_runtime_dependency "json"
end
