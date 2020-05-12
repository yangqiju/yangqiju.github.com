# -*- encoding: utf-8 -*-
# stub: jekyll-minibundle 2.2.0 ruby lib

Gem::Specification.new do |s|
  s.name = "jekyll-minibundle".freeze
  s.version = "2.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Tuomas Kareinen".freeze]
  s.date = "2017-03-10"
  s.description = "A straightforward asset bundling plugin for Jekyll, utilizing external\nminification tool of your choice. It provides asset concatenation for\nbundling and asset fingerprinting with MD5 digest for cache busting.\nThere are no other runtime dependencies besides the minification tool\n(not even other gems).\n".freeze
  s.email = "tkareine@gmail.com".freeze
  s.homepage = "https://github.com/tkareine/jekyll-minibundle".freeze
  s.licenses = ["MIT".freeze]
  s.rdoc_options = ["--line-numbers".freeze, "--title".freeze, "jekyll-minibundle".freeze, "--exclude".freeze, "test".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.0.0".freeze)
  s.rubygems_version = "3.0.3".freeze
  s.summary = "A minimalistic asset bundling plugin for Jekyll".freeze

  s.installed_by_version = "3.0.3" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<benchmark-ips>.freeze, ["~> 2.7"])
      s.add_development_dependency(%q<jekyll>.freeze, ["~> 3.0"])
      s.add_development_dependency(%q<minitest>.freeze, ["~> 5.8"])
      s.add_development_dependency(%q<nokogiri>.freeze, ["~> 1.6"])
      s.add_development_dependency(%q<pry>.freeze, ["~> 0.10"])
      s.add_development_dependency(%q<rake>.freeze, ["~> 12.0"])
      s.add_development_dependency(%q<rubocop>.freeze, ["~> 0.47.0"])
    else
      s.add_dependency(%q<benchmark-ips>.freeze, ["~> 2.7"])
      s.add_dependency(%q<jekyll>.freeze, ["~> 3.0"])
      s.add_dependency(%q<minitest>.freeze, ["~> 5.8"])
      s.add_dependency(%q<nokogiri>.freeze, ["~> 1.6"])
      s.add_dependency(%q<pry>.freeze, ["~> 0.10"])
      s.add_dependency(%q<rake>.freeze, ["~> 12.0"])
      s.add_dependency(%q<rubocop>.freeze, ["~> 0.47.0"])
    end
  else
    s.add_dependency(%q<benchmark-ips>.freeze, ["~> 2.7"])
    s.add_dependency(%q<jekyll>.freeze, ["~> 3.0"])
    s.add_dependency(%q<minitest>.freeze, ["~> 5.8"])
    s.add_dependency(%q<nokogiri>.freeze, ["~> 1.6"])
    s.add_dependency(%q<pry>.freeze, ["~> 0.10"])
    s.add_dependency(%q<rake>.freeze, ["~> 12.0"])
    s.add_dependency(%q<rubocop>.freeze, ["~> 0.47.0"])
  end
end
