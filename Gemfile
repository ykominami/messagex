source "https://rubygems.org"

# Specify your gem's dependencies in messagex.gemspec
gemspec

gem "bundler"
gem "rake", "~> 13.0"
gem "activesupport" , "~> 7.0.7.1"
gem "rack" , "~> 3.0.9.1"

group :test, optional: true do
  gem 'rspec'
  gem 'rubocop'
  gem "rubocop-performance"
  gem 'rubocop-rake', require: false
  gem 'rubocop-rspec', require: false
end

group :development do
  gem 'yard', "~> 0.9.36"
end
