class CreateSmsboxApiSms < ActiveRecord::Migration
  def change
    create_table :smsbox_api_sms do |t|
      t.integer :direction_cd
      t.text :api_response
      t.string :number
      t.text :mode
      t.text :message
      t.string :reference
      t.integer :ack
      t.timestamp :ack_time
      t.timestamp :reception_time

      t.timestamps
    end
  end
end
