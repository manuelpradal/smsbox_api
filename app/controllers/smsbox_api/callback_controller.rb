module SmsboxApi
  class CallbackController < ApplicationController
    before_filter :check_empty_call

    def check_empty_call
      if (params.keys - ["action", "controller"]).empty?
        render nothing: true
        return
      end
    end

    def sms_ack
      SmsboxApi::Sms.receive_ack params
      render nothing: true
    end

    def sms_response
      SmsboxApi::Sms.receive_response params
      render nothing: true
    end
  end
end
