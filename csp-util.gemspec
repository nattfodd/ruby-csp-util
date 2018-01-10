# frozen_string_literal: true

require_relative 'lib/csp_util/version'

Gem::Specification.new do |s|
  s.name     = 'csp-util'
  s.licenses = ['MIT']
  s.version  = CSPUtil::VERSION
  s.summary  = 'Content-Security-Policy utils'
  s.authors  = ['Templarbit']
  s.homepage = 'https://github.com/templarbit/ruby-csp-util'
  s.files    = `git ls-files -z`.split("\x0")
                                .reject do |f|
                                  f.match(%r{^(test|spec|features)/})
                                end
  s.executables = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.required_ruby_version = '~> 2.2'

  s.require_paths = ['lib']

  s.add_development_dependency 'pry'
  s.add_development_dependency 'rspec', '~> 3.7'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'simplecov'
end
