# frozen_string_literal: true

require 'roda'
require 'figaro'
require 'logger'
require 'rack/session'

module Credence
  # Configuration for the API
  class App < Roda
    plugin :environments

    # Environment variables setup
    Figaro.application = Figaro::Application.new(
      environment:,
      path: File.expand_path('config/secrets.yml')
    )
    Figaro.load
    def self.config = Figaro.env

    # Session configuration
    ONE_MONTH = 30 * 24 * 60 * 60
    use Rack::Session::Cookie,
        expire_after: ONE_MONTH,
        secret: config.SESSION_SECRET

    # HTTP Request logging
    configure :development, :production do
      plugin :common_logger, $stdout
    end

    # Custom events logging
    LOGGER = Logger.new($stderr)
    def self.logger = LOGGER

    configure :development, :test do
      logger.level = Logger::ERROR
    end

    # Console/Pry configuration
    configure :development, :test do
      require 'pry'

      # Allows running reload! in pry to restart entire app
      def self.reload!
        exec 'pry -r ./spec/test_load_all'
      end
    end
  end
end
