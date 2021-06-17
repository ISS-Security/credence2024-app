# frozen_string_literal: true

require 'http'

module Credence
  # Returns an authenticated user, or nil
  class VerifyRegistration
    class VerificationError < StandardError; end
    class ApiServerError < StandardError; end

    def initialize(config)
      @config = config
    end

    def call(registration_data)
      reg_details = registration_data.to_h
      registration_token = SecureMessage.encrypt(reg_details)
      reg_details['verification_url'] =
        "#{@config.APP_URL}/auth/register/#{registration_token}"

      response = HTTP.post(
        "#{@config.API_URL}/auth/register",
json: SignedMessage.sign(reg_details)
      )

      raise(VerificationError) unless response.code == 202

      JSON.parse(response.to_s)
    rescue HTTP::ConnectionError
      raise(ApiServerError)
    end
  end
end
