# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "drug-bot-nerdpursuit/version"

Gem::Specification.new do |s|
  s.name        = "drug-bot-nerdpursuit"
  s.version     = Nerdpursuit::VERSION
  s.authors     = ["Piotr Niełacny"]
  s.email       = ["piotr.nielacny@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Nerdpursuit plugin for DRUG-bot}
  s.description = %q{Frontend for NerdPursuit .json questions bag}

  s.rubyforge_project = "drug-bot-nerdpursuit"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency "drug-bot", "~> 0.0.1"
end
