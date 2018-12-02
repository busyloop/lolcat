# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "lolcat/version"

Gem::Specification.new do |s|
  s.name        = "lolcat"
  s.version     = Lolcat::VERSION
  s.authors     = ["Moe"]
  s.email       = ["moe@busyloop.net"]
  s.homepage    = "https://github.com/busyloop/lolcat"
  s.description = %q{Rainbows and unicorns!}
  s.summary     = %q{Okay, no unicorns. But rainbows!!}

  s.add_development_dependency "rake"
  s.add_dependency "paint", "~> 2.0.0"
  s.add_dependency "optimist", "~> 3.0.0"
  s.add_dependency "manpages", "~> 0.6.1"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
