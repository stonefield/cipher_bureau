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

class CipherBureau::Password
  attr_reader :length, :options
  
  class << self
    def random(*args)
      enum :random, *args
    end
    
    def letters_and_numbers(*args)
      enum :letters_and_numbers, *args
    end

    def numbers_only(*args)
      enum :numbers_only, *args
    end
    
    def symbols_and_numbers(*args)
      enum :symbols_and_numbers, *args
    end

    def memorable(*args)
      enum :memorable, *args
    end
    
    def strength(password)
      CipherBureau::PasswordMeter.strength(password)
    end
    
    private
      def enum(method, *args)
        options = args.extract_options!
        count = args.first || 1
        as_hash = options.delete(:as) == :hash
        if options.delete(:strength)
          res = count.times.collect do
            s = strength( p = self.new(options).send(method) )
            as_hash ? {:password => p, :strength => s } : [p, s] 
          end
        else
          res = count.times.collect { self.new(options).send(method) }
        end
        count == 1 ? res.first : res
      end
  end
  
  def initialize(options = {})
    @options = options.reverse_merge(CipherBureau.default_memorable_options)
    @options.assert_valid_keys(:length, :country_code, :ascii, :grammar, :name_type, :camelize, :middle_numbers)
    @length = @options.delete(:length) || CipherBureau.password_length
    raise ArgumentError, 'Password length is undefined.' unless @length
    @options.delete(:name_type) unless @options[:grammar] == 'name'
  end
  
  NUMBERS = ('0'..'9').to_a
  RANDOM = ('!'..'~').to_a
  LETTERS_AND_NUMBERS = ('a'..'z').to_a + ('A'..'Z').to_a + NUMBERS
  SYMBOLS_AND_NUMBERS = RANDOM - ('a'..'z').to_a - ('A'..'Z').to_a
  
  def random(size = length)
    (0...size).map{RANDOM.sample}.join
  end


  def letters_and_numbers(size = length)
    (0...size).map{LETTERS_AND_NUMBERS.sample}.join
  end

  def numbers_only(size = length)
    (0...size).map{NUMBERS.sample}.join
  end

  def memorable()
    sym_size = length / 4   
    end_size = (length - sym_size) / 2
    beg_size = length - end_size - sym_size
    # puts "beg_size: #{beg_size} sym_size: #{sym_size} end_size: #{end_size}"
    beg_word = CipherBureau::Dictionary.random(beg_size, scope)
    end_word = CipherBureau::Dictionary.random(end_size, scope)
    sym_word = options[:middle_numbers] ? numbers_only(sym_size) : symbols_and_numbers(sym_size)
    "#{beg_word}#{sym_word}#{end_word}"
  end
  
  def symbols_and_numbers(size = length)
    (0...size).map{SYMBOLS_AND_NUMBERS.sample}.join
  end

protected
  def scope
    options.slice(:length, :country_code, :ascii, :grammar, :name_type, :camelize)
  end

end