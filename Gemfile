source "https://rubygems.org"

# Specify your gem's dependencies in messagex.gemspec
gemspec

gem "bundler"
gem "rake", "~> 13.0"

group :test, optional: true do
  gem 'rspec'
  gem 'rubocop'
  gem "rubocop-performance"
  gem 'rubocop-rake', require: false
  gem 'rubocop-rspec', require: false
end

group :development do
  gem 'yard'
end
