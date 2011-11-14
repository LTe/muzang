# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "muzang-motd/version"

Gem::Specification.new do |s|
  s.name        = "muzang-motd"
  s.version     = Motd::VERSION
  s.authors     = ["Piotr Niełacny"]
  s.email       = ["piotr.nielacny@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Motd plugin for DRUG-bot}
  s.description = %q{Motd plugin for DRUG-bot}

  s.rubyforge_project = "muzang-motd"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency "muzang", "~> 0.0.1"
end
