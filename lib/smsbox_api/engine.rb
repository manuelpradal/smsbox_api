module SmsboxApi
  class Engine < ::Rails::Engine
    isolate_namespace SmsboxApi

    mattr_accessor :smsbox_login
    mattr_accessor :smsbox_pass

    config.to_prepare do
      Dir.glob(Rails.root + "app/decorators/**/*_decorator*.rb").each do |c|
        require_dependency(c)
      end
    end
  end
end
