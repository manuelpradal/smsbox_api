module SmsboxApi
  class Sms < ActiveRecord::Base
    validates :number, :message, presence: true

    scope :incoming_sms, -> {where('direction = ?', SmsboxApi::Sms::DIRECTION_INCOMING)}
    scope :outgoing_sms, -> {where('direction = ?', SmsboxApi::Sms::DIRECTION_OUTGOING)}
    scope :with_answer_sms, -> {where('mode = ?', 'Reponse')}

    DIRECTION_INCOMING = 0
    DIRECTION_OUTGOING = 1

    #Must be overriden by main app
    def self.is_allowed_number? number
      false
    end

    def self.send_sms number, message, mode = 'Standard', send_options = {}, additionnal_model_columns = {}
      sms = SmsboxApi::Sms.create({
        direction: DIRECTION_OUTGOING,
        number: number,
        message: message.encode("ISO8859-1"),
        mode: mode
      }.merge(additionnal_model_columns))

      return false unless sms

      request = HTTPI::Request.new(SmsboxApi::Engine::SMSBOX_API_URL)
      request.query = {
        login: SmsboxApi::Engine.smsbox_login,
        pass: SmsboxApi::Engine.smsbox_pass,
        dest: sms.number,
        msg: sms.message,
        mode: sms.mode,
        callback: "1",
        cvar: sms.id,
        id: "1"
      }.merge(send_options)

      return true if Rails.env == 'test'

      #Real send ?
      if is_allowed_number? sms.number
        response = HTTPI.get(request, :net_http).body

        if response.index("OK")
          sms.api_response = "OK"
          sms.reference = response[3..-1]
          sms.save
          sms.handle_sent
          return true
        else
          sms.api_response = response
          sms.save
          sms.handle_sent_fail
          return false
        end
      else
        sms.handle_blacklisted
        return true
      end
    end

    def self.receive_ack params
      sms = SmsboxApi::Sms.where(
        number: params[:numero],
        reference: params[:reference]
      ).first

      if sms
        sms.ack = params[:accuse]
        sms.ack_time = Time.at(params[:ts].to_i)
        #Call ack_callback method (overriden by main application)
        sms.handle_ack
        sms.save
      else
        raise StandardError.new("Ack received for unknown sms #{params[:numero]} #{params[:reference]}")
      end
    end

    def self.receive_response params
      sms = SmsboxApi::Sms.create({
        direction: DIRECTION_INCOMING,
        number: params[:numero],
        reference: params[:reference],
        reception_time: Time.at(params[:ts].to_i),
        message: params[:message]
      })

      sms.handle_response
    end

    #Must be overriden by main app
    def handle_sent
      #NOTHING
    end

    #Must be overriden by main app
    def handle_ack
      #NOTHING
    end

    #Must be overriden by main app
    def handle_response
      #NOTHING
    end

    #Must be overriden by main app
    def handle_blacklisted
      #NOTHING
    end

    #Must be overriden by main app
    def handle_sent_fail
      #NOTHING
    end
  end
end
