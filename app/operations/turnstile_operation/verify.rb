module TurnstileOperation
  # Verifies Turnstile response token.
  class Verify
    attr_reader :response_token

    # @param response_token [String]
    def initialize(response_token:)
      @response_token = response_token
    end

    # @return [TrueClass, FalseClass]
    def call
      unless Turnstile.enabled?
        logger.info "  #{self.class}: Turnstile disabled, responding true and skipping verification"
        return true
      end

      if response_token.blank?
        logger.info "  #{self.class}: Turnstile token is empty, responding false and not skipping verification"
        return false
      end

      logger.info "  #{self.class}: Submitting Turnstile token to siteverify"
      api_response = api_conn.post(
        "turnstile/v0/siteverify",
        response: response_token,
        secret: Turnstile.secret_key
      )

      unless api_response.success?
        msg = "Turnstile API siteverify response status #{api_response.status} - #{api_response.body.inspect}"
        logger.error "#{self.class}: #{msg}"
        raise Error, msg
      end

      unless api_response.body["success"]
        logger.warn "  #{self.class}: Turnstile token verification failed - #{api_response.body.inspect}"
      end

      api_response.body["success"]
    end

    private

    # @return [Faraday::Connection]
    def api_conn
      @api_conn ||= Faraday.new(
        url: "https://challenges.cloudflare.com"
      ) do |f|
        f.request :json
        f.response :json
      end
    end

    # @return [ActiveSupport::Logger]
    def logger
      @logger ||= TurnstileOperation.logger
    end
  end
end
