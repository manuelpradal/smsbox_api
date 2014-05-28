$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "smsbox_api/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "smsbox_api"
  s.version     = SmsboxApi::VERSION
  s.authors     = ["Manuel PRADAL"]
  s.email       = ["manuel.pradal@koolicar.com"]
  s.homepage    = "https://github.com/manuelpradal/smsbox_api"
  s.summary     = "Simple engine to connect to SmsBox HTTP API"
  s.description = "Description of SmsboxApi."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails"

  s.add_development_dependency "pg"

  s.add_development_dependency "simple_enum"
  s.add_development_dependency "pry-rails"
  s.add_development_dependency "pry"
  s.add_development_dependency "httpi"
end
