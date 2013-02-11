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

class CipherBureau::Statistic < ActiveRecord::Base
  validates_presence_of :country_code, :grammar, :length

  class << self
    # register updates word statistics
    def register(word)
      stat = where(:country_code => word.country_code, :grammar => word.grammar, :name_type => word.name_type, 
        :ascii => word.ascii, :length => word.word.length).first_or_initialize
      stat.word_count += 1
      stat.save!
      stat
    end
    
    # returns number of words indatabase based on selection criteria
    #
    #  Examples:
    #    word_count(5) => number of words with length 5
    #    word_count(:ascii => true)  number of wordss with true ascii
    #    word_count(5, :ascii => true)  number of wordsof length 5, with true ascii
    def word_count(*args)
      criteria = args.extract_options!
      criteria.merge!(:length => args.first) if args.first
      where(criteria).sum(:word_count)
    end
  end
end
