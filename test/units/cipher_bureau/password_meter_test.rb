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

# encoding: utf-8
require 'test_helper'

class CipherBureau::PasswordMeterTest < ActiveSupport::TestCase
  # Algorihm:
  # See http://www.passwordmeter.com
  setup do
    @m = CipherBureau::PasswordMeter.new('12345678')
  end
  
  def t(method, expected, password = nil)
    @m.password = password if password
    actual = @m.send(method)
    assert_equal expected, actual, "Method: #{method} with password '#{@m.password}' expected to return #{expected}, was #{actual}"
  end
  
  context 'strength' do
    should 'calculate weak' do
      @m.password = 'aaaaaaaaaaaa'
      assert_equal 48 - 12 - 124 - 22, @m.absolute_score
      assert_equal 0, @m.strength
    end
    should 'calculate strong' do
      @m.password = 'acgHY79-|/'
      assert_equal 40 + 16 + 14 + 8 + 18 + 8 + 10 - 2 - 4 - 2, @m.absolute_score
      assert_equal 100, @m.strength
    end
    should 'also be a class method' do
      assert_equal 100, CipherBureau::PasswordMeter.strength( 'acgHY79-|/')
    end
  end
  
  
  context 'addition' do
    should 'return the expected results' do
      t :number_of_characters, 8 * 4
      t :uppercase_letters, (7 - 3 ) * 2, 'AbCdefG'
      t :uppercase_letters, 0, 'aaaaaaaaaaa'
      t :lowercase_letters, (7 - 4) * 2, 'AbCdefG'
      t :lowercase_letters, 0, 'aaaaaaaaaaa'
      t :lowercase_letters, 2, 'aaaaaaaaaaA'
      t :numbers, 0, '12345678'
      t :numbers, 8 * 4, 'a12345678'
      t :symbols, 3 * 6, 'abcdef[]|'
      t :middle_numbers_or_symbols, 0, '11'
      t :middle_numbers_or_symbols, 2 * 2, 'ab12a'
      t :middle_numbers_or_symbols, 2 * 2, 'ab[]a'
      t :middle_numbers_or_symbols, 2 * 4, 'ab[12]a'
      t :requirements, 0, '12'
      t :requirements, 0, 'abcdefghi'
      t :requirements, 0, 'abcde1234'
      t :requirements, 0, 'abcde[]&:'
      t :requirements, 10, 'AbB=-123i'
      t :requirements, 8, 'AbB12345'
    end
  end
  
  context 'deduction' do
    should 'return representative values for letters only' do
      t :letters_only, 5, 'abcde'
      t :letters_only, 5, 'ABCDE'
      t :letters_only, 5, 'AbCdE'
      t :letters_only, 0, 'AbCd1'
      t :letters_only, 0, '12345'
      t :letters_only, 0, 'AbCd['
      t :letters_only, 0, ';:`?=)'
    end
    should 'return representative values for numbers only' do
      t :numbers_only, 5, '54321'
      t :numbers_only, 0, '5432a'
      t :numbers_only, 0, ';:`?=)'
      t :numbers_only, 0, 'ABCDE'
    end
    should 'return representative values for repeated_characters' do
      t :repeated_characters, 37, '11111'
      t :repeated_characters, 15, '11211'
      t :repeated_characters, 3, 'aa2b1'
    end
    should 'return representative values for sequential_letters' do
      t :sequential_letters, 3, 'ABC'
      t :sequential_letters, 3, 'BCD'
      t :sequential_letters, 6, 'ABCD'
      t :sequential_letters, 6, 'DCBA'
    end
    should 'return representative values for sequential_numbers' do
      t :sequential_numbers, 6, '1234'     
      t :sequential_numbers, 6, '4321'
      t :sequential_numbers, 9, '54321'
    end
    should 'return representative values for sequential_symbols' do
      t :sequential_symbols, 21, '!@#$%^&*()'             
    end
    should 'return representative values for consecutive_uppercase' do
      t :consecutive_uppercase, 6, 'ACEG'             
      t :consecutive_uppercase, 12, 'ACEGsKJSNks'             
    end
    should 'return representative values for consecutive_lowercase' do
      t :consecutive_lowercase, 6, 'aceg'
      t :consecutive_lowercase, 10, 'acegABkjjJ'
    end
    should 'return representative values for consecutive_numbers' do
      t :consecutive_numbers, 6, '1357'
      t :consecutive_numbers, 8, 'ab10357CD'
    end
  end
end