# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "bezebe-cvs/version"

Gem::Specification.new do |gem|
    gem.name        = "bezebe-cvs"
    gem.version     = Bezebe::CVS::VERSION
    gem.authors     = ["Tnarik Innael"]
    gem.email       = ["tnarik@gmail.com"]
    gem.summary     = "bussy bee CVS"
    gem.description = "a set of tools for the bussy bee - CVS"
    gem.homepage    = "http://github.com/tnarik/bezebe-cvs"
    gem.license     = "MIT"

    gem.rubyforge_project = "bezebe"

    gem.files         = `git ls-files`.split("\n")
    gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
    gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
    gem.require_paths = ["lib"]

    # runtime dependencies
    gem.add_runtime_dependency "rjb"

    # devevelopment dependencies
    gem.add_development_dependency "thor"
    gem.add_development_dependency "bundler"

    # testing
    gem.add_development_dependency 'rspec'
end
