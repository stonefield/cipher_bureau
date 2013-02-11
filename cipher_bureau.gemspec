$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "cipher_bureau/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "cipher_bureau"
  s.version     = CipherBureau::VERSION
  s.authors     = ["Knut I. Stenmark"]
  s.email       = ["knut.stenmark@gmail.com"]
  s.homepage    = "https://github.com/stonefield/cipher_bureau"
  s.summary     = "CipherBureau is a simple gem for password generation"
  s.description = "Sometimes you need to generate passwords in your application.
  This gem does exactly that. It also has the ability to measure the strength of passwords.
  In addition it contains a dictionary for creating memorable passwords. 
  Currently the dictionary is only in Norwegian, but you can easily load dictionaries yourself."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"] - Dir['test/dummy/db/*.sqlite3', 'test/dummy/log/*.log', 'test/dummy/tmp/', 'test/dummy/.sass-cache']

  s.add_dependency "rails", ">= 3.0"
  s.add_dependency "unicode_utils", ">= 1.3.0"

  s.add_development_dependency "sqlite3"
end
