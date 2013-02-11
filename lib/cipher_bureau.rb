# Copyright (c) 2013 Dynamic Project Management AS
# Copyright (c) 2013 Knut I. Stenmark
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

require 'cipher_bureau/exceptions'
module CipherBureau
  def self.table_name_prefix
    'cipher_bureau_'
  end
  
  autoload :Statistic,      'cipher_bureau/statistic'
  autoload :Dictionary,     'cipher_bureau/dictionary'
  autoload :Password,       'cipher_bureau/password'
  autoload :PasswordMeter,  'cipher_bureau/password_meter'
  autoload :DataLoader,     'cipher_bureau/data_loader'
  
  include ActiveSupport::Configurable
  
  # Default password length
  config_accessor :password_length
  
  # Oprions to use for memorable passwords
  # 
  #   Valid options:
  #
  #     :country_code - a numerical value of country_code, e.g. Norway 47
  #     :ascii - true of false. Use false to get words outside 7-bits range, such as nordic characters
  #     :grammar - legal values are: 'adjective','adverb','conjunction','determiner','interjection','name','noun',
  #               'musical','numeral','preposition','pronoun','subjunctive','verb','verbalsubst',
  #     :name_tupe - if grammar is specified, you can optionally specify: 'boysname','girlsname', 'surname'
  #
  config_accessor :default_memorable_options

  self.default_memorable_options ||= {}

  # Sets repository location for langage files
  config_accessor :language_repository
  
  self.language_repository ||= "http://dictionaries.cipher-bureau.net"
  
end
