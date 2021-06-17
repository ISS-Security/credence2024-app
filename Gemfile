# frozen_string_literal: true

source 'https://rubygems.org'
ruby File.read('.ruby-version').strip

# Web
gem 'puma', '~>6.0'
gem 'rack-session', '~>2.0'
gem 'redis-rack'
gem 'redis-store'
gem 'roda', '~>3.54'
gem 'slim'

# Configuration
gem 'figaro', '~>1.2'
gem 'rake', '~>13.0'

# Communication
gem 'http', '~>5.1'
gem 'redis', '~>5.0'

# Security
gem 'dry-validation', '~>1.10'
gem 'rack-ssl-enforcer'
gem 'rbnacl', '~>7.1'
gem 'secure_headers'

# Encoding
gem 'base64', '~>0.2'

# Debugging
gem 'pry'
gem 'rack-test'

# Development
group :development do
  gem 'rubocop'
  gem 'rubocop-performance'
end

# Testing
group :test do
  gem 'minitest'
  gem 'minitest-rg'
  gem 'webmock'
end

group :development, :test do
  gem 'rerun'
end
