# -*- encoding: utf-8 -*-
# stub: rbnacl 3.4.0 ruby lib

Gem::Specification.new do |s|
  s.name = "rbnacl".freeze
  s.version = "3.4.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Tony Arcieri".freeze, "Jonathan Stott".freeze]
  s.cert_chain = ["bascule.cert".freeze]
  s.date = "2016-05-07"
  s.description = "Ruby binding to the Networking and Cryptography (NaCl) library".freeze
  s.email = ["tony.arcieri@gmail.com".freeze, "jonathan.stott@gmail.com".freeze]
  s.homepage = "https://github.com/cryptosphere/rbnacl".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "2.7.7".freeze
  s.summary = "The Networking and Cryptography (NaCl) library provides a high-level toolkit for building cryptographic systems and protocols".freeze

  s.installed_by_version = "2.7.7" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<ffi>.freeze, [">= 0"])
      s.add_development_dependency(%q<rake>.freeze, [">= 0"])
      s.add_development_dependency(%q<rspec>.freeze, ["~> 3.0.0"])
      s.add_development_dependency(%q<rubocop>.freeze, [">= 0"])
    else
      s.add_dependency(%q<ffi>.freeze, [">= 0"])
      s.add_dependency(%q<rake>.freeze, [">= 0"])
      s.add_dependency(%q<rspec>.freeze, ["~> 3.0.0"])
      s.add_dependency(%q<rubocop>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<ffi>.freeze, [">= 0"])
    s.add_dependency(%q<rake>.freeze, [">= 0"])
    s.add_dependency(%q<rspec>.freeze, ["~> 3.0.0"])
    s.add_dependency(%q<rubocop>.freeze, [">= 0"])
  end
end
