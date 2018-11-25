# -*- encoding: utf-8 -*-
# stub: discordrb 3.3.0 ruby lib

Gem::Specification.new do |s|
  s.name = "discordrb".freeze
  s.version = "3.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "changelog_uri" => "https://github.com/meew0/discordrb/blob/master/CHANGELOG.md" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["meew0".freeze]
  s.bindir = "exe".freeze
  s.date = "2018-10-28"
  s.description = "A Ruby implementation of the Discord (https://discordapp.com) API.".freeze
  s.email = ["".freeze]
  s.homepage = "https://github.com/meew0/discordrb".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.2.4".freeze)
  s.rubygems_version = "2.7.7".freeze
  s.summary = "Discord API for Ruby".freeze

  s.installed_by_version = "2.7.7" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rest-client>.freeze, [">= 2.1.0.rc1"])
      s.add_runtime_dependency(%q<opus-ruby>.freeze, [">= 0"])
      s.add_runtime_dependency(%q<websocket-client-simple>.freeze, [">= 0.3.0"])
      s.add_runtime_dependency(%q<rbnacl>.freeze, ["~> 3.4.0"])
      s.add_runtime_dependency(%q<ffi>.freeze, [">= 1.9.24"])
      s.add_runtime_dependency(%q<discordrb-webhooks>.freeze, ["~> 3.3.0"])
      s.add_development_dependency(%q<bundler>.freeze, ["~> 1.10"])
      s.add_development_dependency(%q<rake>.freeze, ["~> 10.0"])
      s.add_development_dependency(%q<yard>.freeze, ["~> 0.9.9"])
      s.add_development_dependency(%q<redcarpet>.freeze, ["~> 3.4.0"])
      s.add_development_dependency(%q<rspec>.freeze, ["~> 3.4.0"])
      s.add_development_dependency(%q<rspec-prof>.freeze, ["~> 0.0.7"])
      s.add_development_dependency(%q<rubocop>.freeze, ["= 0.49.1"])
      s.add_development_dependency(%q<simplecov>.freeze, ["~> 0.16.0"])
    else
      s.add_dependency(%q<rest-client>.freeze, [">= 2.1.0.rc1"])
      s.add_dependency(%q<opus-ruby>.freeze, [">= 0"])
      s.add_dependency(%q<websocket-client-simple>.freeze, [">= 0.3.0"])
      s.add_dependency(%q<rbnacl>.freeze, ["~> 3.4.0"])
      s.add_dependency(%q<ffi>.freeze, [">= 1.9.24"])
      s.add_dependency(%q<discordrb-webhooks>.freeze, ["~> 3.3.0"])
      s.add_dependency(%q<bundler>.freeze, ["~> 1.10"])
      s.add_dependency(%q<rake>.freeze, ["~> 10.0"])
      s.add_dependency(%q<yard>.freeze, ["~> 0.9.9"])
      s.add_dependency(%q<redcarpet>.freeze, ["~> 3.4.0"])
      s.add_dependency(%q<rspec>.freeze, ["~> 3.4.0"])
      s.add_dependency(%q<rspec-prof>.freeze, ["~> 0.0.7"])
      s.add_dependency(%q<rubocop>.freeze, ["= 0.49.1"])
      s.add_dependency(%q<simplecov>.freeze, ["~> 0.16.0"])
    end
  else
    s.add_dependency(%q<rest-client>.freeze, [">= 2.1.0.rc1"])
    s.add_dependency(%q<opus-ruby>.freeze, [">= 0"])
    s.add_dependency(%q<websocket-client-simple>.freeze, [">= 0.3.0"])
    s.add_dependency(%q<rbnacl>.freeze, ["~> 3.4.0"])
    s.add_dependency(%q<ffi>.freeze, [">= 1.9.24"])
    s.add_dependency(%q<discordrb-webhooks>.freeze, ["~> 3.3.0"])
    s.add_dependency(%q<bundler>.freeze, ["~> 1.10"])
    s.add_dependency(%q<rake>.freeze, ["~> 10.0"])
    s.add_dependency(%q<yard>.freeze, ["~> 0.9.9"])
    s.add_dependency(%q<redcarpet>.freeze, ["~> 3.4.0"])
    s.add_dependency(%q<rspec>.freeze, ["~> 3.4.0"])
    s.add_dependency(%q<rspec-prof>.freeze, ["~> 0.0.7"])
    s.add_dependency(%q<rubocop>.freeze, ["= 0.49.1"])
    s.add_dependency(%q<simplecov>.freeze, ["~> 0.16.0"])
  end
end
