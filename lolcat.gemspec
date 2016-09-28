# -*- encoding: utf-8 -*-
# frozen_string_literal: true
$LOAD_PATH.push File.expand_path('../lib', __FILE__)
require 'lolcat/version'

Gem::Specification.new do |s|
  s.name        = 'lolcat'
  s.version     = Lolcat::VERSION
  s.authors     = ['Moe']
  s.email       = ['moe@busyloop.net']
  s.homepage    = 'https://github.com/busyloop/lolcat'
  s.description = 'Rainbows and unicorns!'
  s.summary     = 'Okay, no unicorns. But rainbows!!'

  s.add_development_dependency 'rake'
  s.add_dependency 'paint', '~> 1.0.0'
  s.add_dependency 'trollop', '~> 2.1.2'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ['lib']
end
