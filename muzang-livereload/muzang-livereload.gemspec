# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "muzang-livereload/version"

Gem::Specification.new do |s|
  s.name        = "muzang-livereload"
  s.version     = Livereload::VERSION
  s.authors     = ["Piotr Niełacny"]
  s.email       = ["piotr.nielacny@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Livereload plugin for DRUG-bot}
  s.description = %q{Livereload plugin for DRUG-bot}

  s.rubyforge_project = "muzang-livereload"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency "muzang", "~> 0.0.1"
end
