# frozen_string_literal: true

# rubocop:disable Style/HashSyntax
require 'rake/testtask'

task :print_env do
  puts "Environment: #{ENV.fetch('RACK_ENV', 'development')}"
end

desc 'Run application console (pry)'
task :console => :print_env do
  sh 'pry -r ./spec/test_load_all'
end

desc 'Rake all the Ruby'
task :style do
  sh 'rubocop .'
end

# Generate new cryptographic keys
namespace :generate do
  desc 'Create cookie secret'
  task :session_secret do
    require 'base64'
    require 'rbnacl'
    session_secret = RbNaCl::Random.random_bytes(64)
    secret64 = Base64.strict_encode64(session_secret)
    puts "New SESSION_SECRET (base64): #{secret64}"
  end
end

namespace :run do
  # Run in development mode
  desc 'Run Web App in development mode'
  task :dev => :print_env do
    sh 'puma -p 9292'
  end
end
# rubocop:enable Style/HashSyntax
