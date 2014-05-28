SmsboxApi::Engine.routes.draw do
  get 'ack' => "callback#sms_ack"
  get 'response' => "callback#sms_response"
end
