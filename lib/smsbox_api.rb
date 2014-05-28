require "smsbox_api/engine"

module SmsboxApi
  class Engine < ::Rails::Engine
    isolate_namespace SmsboxApi
  end
end
