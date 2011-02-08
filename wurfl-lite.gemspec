# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "wurfl-lite/version"

Gem::Specification.new do |s|
  s.name        = "wurfl-lite"
  s.version     = WURFL::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Clive Crous"]
  s.email       = ["clive@crous.co.za"]
  s.homepage    = "http://www.darkarts.co.za/wurfl-lite"
  s.summary     = %q{Simple Ruby usage of the WURFL device capabilities and features database}
  s.description = %q{Simple Ruby usage of the WURFL device capabilities and features database}

  s.add_dependency "hpricot", ">= 0.8.2", "!= 0.8.3"
  s.add_dependency "amatch", ">= 0.2.5"

  s.add_development_dependency "bundler", ">= 1.0.0"
  s.add_development_dependency "rake", ">= 0.8.7"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
