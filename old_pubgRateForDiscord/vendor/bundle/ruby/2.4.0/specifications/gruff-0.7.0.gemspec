# -*- encoding: utf-8 -*-
# stub: gruff 0.7.0 ruby lib

Gem::Specification.new do |s|
  s.name = "gruff".freeze
  s.version = "0.7.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Geoffrey Grosenbach".freeze, "Uwe Kubosch".freeze]
  s.date = "2016-06-01"
  s.description = "Beautiful graphs for one or multiple datasets. Can be used on websites or in documents.".freeze
  s.email = "boss@topfunky.com".freeze
  s.homepage = "https://github.com/topfunky/gruff".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(["< 3".freeze, ">= 1.9.3".freeze])
  s.rubygems_version = "2.7.7".freeze
  s.summary = "Beautiful graphs for one or multiple datasets.".freeze

  s.installed_by_version = "2.7.7" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rmagick>.freeze, [">= 2.13.4", "~> 2.13"])
      s.add_development_dependency(%q<rake>.freeze, [">= 0"])
      s.add_development_dependency(%q<minitest-reporters>.freeze, [">= 0"])
    else
      s.add_dependency(%q<rmagick>.freeze, [">= 2.13.4", "~> 2.13"])
      s.add_dependency(%q<rake>.freeze, [">= 0"])
      s.add_dependency(%q<minitest-reporters>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<rmagick>.freeze, [">= 2.13.4", "~> 2.13"])
    s.add_dependency(%q<rake>.freeze, [">= 0"])
    s.add_dependency(%q<minitest-reporters>.freeze, [">= 0"])
  end
end
