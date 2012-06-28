# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require 'muzang/version'

Gem::Specification.new do |s|
  s.name        = "muzang"
  s.version     = Muzang::VERSION
  s.authors     = ["Piotr Niełacny", "Paweł Pacana"]
  s.email       = ["piotr.nielacny@gmail.com", "pawel.pacana@gmail.com"]
  s.homepage    = "https://github.com/LTe/muzang"
  s.summary     = %q{Dolnoslaska Ruby User Group IRC bot}
  s.description = %q{IRC bot with easy plugin managment}

  s.rubyforge_project = "muzang"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency "coffeemaker", "~> 0.1.0"
end
