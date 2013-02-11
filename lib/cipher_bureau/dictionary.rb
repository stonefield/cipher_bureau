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

require 'unicode_utils'
class CipherBureau::Dictionary < ActiveRecord::Base
  attr_accessible :word, :grammar, :country_code, :name_type
  
  validates_presence_of :word, :grammar, :country_code
  
  before_save do
    self.length = word.length
    self.ascii = !!(word =~ /^[a-z]+$/)
    true
  end
  
  after_create do
    CipherBureau::Statistic.register(self)
  end
  
  class << self
    def random(*args)
      criteria = args.extract_options!
      camelize = criteria.delete(:camelize)
      criteria.merge!(:length => args.first) if args.first
      r = fetch_random_word(criteria)
      r && (camelize ? capitalize(r.word) : r.word)
    end
    
  private
    def randomized_offset(offset)
      rand(offset)
    end
    
    def fetch_random_word(criteria)
      n = CipherBureau::Statistic.word_count(criteria) # get number of elements satisfying criteria
      where(criteria).offset(randomized_offset(n)).limit(1).first      
    end
    
    def capitalize(word)
      UnicodeUtils.upcase(word[0]) + word[1..-1]
    end
  end
  
end