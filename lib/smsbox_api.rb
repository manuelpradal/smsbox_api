require "smsbox_api/engine"
require "httpi"

module SmsboxApi
  class Engine < ::Rails::Engine
    isolate_namespace SmsboxApi

    SMSBOX_API_URL = 'http://api.smsbox.fr/api.php'
  end
end
