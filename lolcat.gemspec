# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "lolcat/version"

Gem::Specification.new do |s|
  s.name        = "lolcat"
  s.version     = Lolcat::VERSION
  s.authors     = ["Moe"]
  s.email       = ["moe@busyloop.net"]
  s.homepage    = "https://github.com/ehrenmurdick/lolcat"
  s.description = %q{Rainbows and unicorns!}
  s.summary     = %q{Okay, no unicorns. But rainbows!!}

  #s.rubyforge_project = "lolcat"
  s.add_dependency "paint", "~> 0.8.3"
  s.add_dependency "trollop", "~> 1.16.2"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
