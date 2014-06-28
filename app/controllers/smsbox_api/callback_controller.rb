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
      begin
        SmsboxApi::Sms.receive_ack params
      rescue => e
        render nothing: true
      end
    end

    def sms_response
      begin
        SmsboxApi::Sms.receive_response params
      rescue => e
        render nothing: true
      end
    end
  end
end
