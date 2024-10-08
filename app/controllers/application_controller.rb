class ApplicationController < ActionController::Base
  before_action :require_basic_auth

  MOBILE_USER_AGENTS =  'palm|blackberry|nokia|phone|midp|mobi|symbian|chtml|ericsson|minimo|' +
                    'audiovox|motorola|samsung|telit|upg1|windows ce|ucweb|astel|plucker|' +
                    'x320|x240|j2me|sgh|portable|sprint|docomo|kddi|softbank|android|mmp|' +
                    'pdxgw|netfront|xiino|vodafone|portalmmm|sagem|mot-|sie-|ipod|up\\.b|' +
                    'webos|amoi|novarra|cdm|alcatel|pocket|iphone|mobileexplorer|mobile'
  def is_mobile?
    agent_str = request.user_agent.to_s.downcase
    return false if agent_str =~ /ipad|macintosh/
    return !!(agent_str =~ Regexp.new(MOBILE_USER_AGENTS))
  end

  protected

  # Require basic user/pass auth when enabled.
  def require_basic_auth
    if ENV.fetch("ENABLE_BASIC_AUTH", "false") == "true"
      http_basic_authenticate_or_request_with(
        name: ENV.fetch("BASIC_AUTH_USERNAME", "admin"),
        password: ENV.fetch("BASIC_AUTH_PASSWORD", "sistemafacturacionadescobam")
      )
    end
  end
end
