smsbox_api
==========

Simple engine to connect to SmsBox HTTP API

Requirement
===========

Rails 4.0.0 or later.

Installation
============

`gem 'smsbox_api', git: 'https://github.com/manuelpradal/smsbox_api.git'`

Install migrations : `rake smsbox_api:install:migrations`. It creates a new migration in your `db/migrate` directory.
Run migration : `rake db:migrate`

Mount the engine in your `config/routes.rb` file :

<pre><code>mount SmsboxApi::Engine => "/your_mount_point"</code></pre>

This line makes the following URLs available :
`/your_mount_point/ack`, used by SmsBox for ack callbacks
`/your_mount_point/response`, used by SmsBox for sms in response to Sms sent with mode 'Reponse'

Configuration
=============

In your application.rb file, or inside an initializer, add these lines :

<pre><code>module YourApp
  class Application < Rails::Application
    config.to_prepare do
      SmsboxApi::Engine.smsbox_login = "YourSMSBoxLogin"
      SmsboxApi::Engine.smsbox_pass = "YourSMSBoxPass"
    end
  end
end</code></pre>

Send a SMS easily
=================

`SmsboxApi::Sms.send_sms 'number_without_+_char', 'Your sms content'`

It creates a record in `smsbox_api_sms` table.

Customizations
==============

Create a decorator in your main app in `app/decorators/models/smsbox_api/sms_decorator.rb` file :

<pre><code>SmsboxApi::Sms.class_eval do
  #This method is called for each sms send attempt,
  #to check if a real sms must be sent to this number
  def self.is_allowed_number? number
    #Example
    return !black_list.include?(number)
  end

  def handle_ack
    #NOTHING
  end

  #Must be overriden by main app
  def handle_response
    #NOTHING
  end

  #Must be overriden by main app
  def blacklisted
    pr "send sms #{self.inspect}"
  end
end</code></pre>

You can also add custom columns to Sms model, to add callbacks for ack or response to a sent sms.