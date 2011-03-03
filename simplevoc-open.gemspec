# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{simplevoc-open}
  s.version = "1.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["triAGENS GmbH", "Oliver Kiessler"]
  s.date = %q{2011-03-02}
  s.description = %q{Easy installation, easy administration and simple to use is the focus of the SimpleVOC. It is a pure in-memory key/value store with a REST interface. Unlike other key/value stores the SimpleVOC provides a prefix search!}
  s.email = %q{kiessler@inceedo.com}
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.md"
  ]
  s.files = [
    ".document",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE.txt",
    "README.md",
    "Rakefile",
    "VERSION",
    "config.yml.sample",
    "lib/simplevoc-open.rb",
    "lib/simplevoc/open/base.rb",
    "lib/simplevoc/open/client.rb",
    "lib/simplevoc/open/configuration.rb",
    "lib/simplevoc/open/exceptions.rb",
    "lib/simplevoc/open/hash.rb",
    "simplevoc-open.gemspec",
    "test/config.yml",
    "test/helper.rb",
    "test/test_client.rb",
    "test/test_hash.rb",
    "test/test_non_strict_client.rb",
    "test/test_simplevoc.rb"
  ]
  s.homepage = %q{http://www.worldofvoc.com/products/simplevoc/summary/}
  s.licenses = ["Apache License Version 2.0, January 2004"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.5.2}
  s.summary = %q{A pure in-memory key/value store with a REST interface}
  s.test_files = [
    "test/helper.rb",
    "test/test_client.rb",
    "test/test_hash.rb",
    "test/test_non_strict_client.rb",
    "test/test_simplevoc.rb"
  ]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<httparty>, [">= 0.7.4"])
      s.add_runtime_dependency(%q<json>, [">= 1.4.6"])
      s.add_development_dependency(%q<shoulda>, [">= 0"])
      s.add_development_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.5.2"])
      s.add_development_dependency(%q<rcov>, [">= 0"])
      s.add_runtime_dependency(%q<httparty>, [">= 0.7.4"])
      s.add_runtime_dependency(%q<json>, [">= 1.4.6"])
    else
      s.add_dependency(%q<httparty>, [">= 0.7.4"])
      s.add_dependency(%q<json>, [">= 1.4.6"])
      s.add_dependency(%q<shoulda>, [">= 0"])
      s.add_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_dependency(%q<jeweler>, ["~> 1.5.2"])
      s.add_dependency(%q<rcov>, [">= 0"])
      s.add_dependency(%q<httparty>, [">= 0.7.4"])
      s.add_dependency(%q<json>, [">= 1.4.6"])
    end
  else
    s.add_dependency(%q<httparty>, [">= 0.7.4"])
    s.add_dependency(%q<json>, [">= 1.4.6"])
    s.add_dependency(%q<shoulda>, [">= 0"])
    s.add_dependency(%q<bundler>, ["~> 1.0.0"])
    s.add_dependency(%q<jeweler>, ["~> 1.5.2"])
    s.add_dependency(%q<rcov>, [">= 0"])
    s.add_dependency(%q<httparty>, [">= 0.7.4"])
    s.add_dependency(%q<json>, [">= 1.4.6"])
  end
end

