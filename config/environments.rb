# frozen_string_literal: true

require 'delegate'
require 'roda'
require 'figaro'
require 'logger'
require 'rack/session'
require 'rack/session/redis'
require_relative '../require_app'

require_app('lib')

module Credence
  # Configuration for the API
  class App < Roda
    plugin :environments

    # Environment variables setup
    Figaro.application = Figaro::Application.new(
      environment: environment,
      path: File.expand_path('config/secrets.yml')
    )
    Figaro.load
    def self.config() = Figaro.env

    # HTTP Request logging
    configure :development, :production do
      plugin :common_logger, $stdout
    end

    # Custom events logging
    LOGGER = Logger.new($stderr)
    def self.logger() = LOGGER

    # Allows binding.pry in dev/test and rake console in production
    require 'pry'

    # Session configuration
    ONE_MONTH = 30 * 24 * 60 * 60
    @redis_url = ENV.delete('REDISCLOUD_URL')
    SecureMessage.setup(ENV.delete('MSG_KEY'))
    SignedMessage.setup(config)
    SecureSession.setup(@redis_url) # only used in dev to wipe session store

    configure :development, :test do
      # Suppresses log info/warning outputs in dev/test environments
      logger.level = Logger::ERROR

      # use Rack::Session::Cookie,
      #     secret: config.SESSION_SECRET,
      #     expire_after: ONE_MONTH,
      #     httponly: true,
      #     same_site: :lax

      use Rack::Session::Pool,
          expire_after: ONE_MONTH,
          httponly: true,
          same_site: :lax

      # use Rack::Session::Redis,
      #     expire_after: ONE_MONTH,
      #     redis_server: @redis_url

      # Allows running reload! in pry to restart entire app
      def self.reload!
        exec 'pry -r ./spec/test_load_all'
      end
    end

    configure :production do
      use Rack::SslEnforcer, hsts: true

      use Rack::Session::Redis,
          expire_after: ONE_MONTH,
          redis_server: @redis_url
    end
  end
end
