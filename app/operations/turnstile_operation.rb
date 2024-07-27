# Handles Cloudflare Turnstile token verification.
module TurnstileOperation
  # @param response_token [String]
  # @return [TrueClass, FalseClass]
  def self.verify(response_token:)
    Verify.new(response_token: response_token).call
  end

  # @return [ActiveSupport::Logger]
  def self.logger
    @logger ||= Rails.logger
  end
end
