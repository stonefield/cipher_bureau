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

class CipherBureau::PasswordMeter
  LETTERS = ('a'..'z').to_a.join
  NUMBERS = (0..9).to_a.join
  SYMBOLS = ')!@#$%^&*()'
  
  attr_reader :password, :length
  def initialize(password)
    self.password = password
  end

  def password=(password)
    @absolute_score = nil
    @length = password.length
    @password = password
  end

  def self.strength(password)
    new(password).strength
  end
  
  def strength
    n = absolute_score  
    n > 100 ? 100 : (n < 0 ? 0 : n )
  end

  def verbose_strength
    case strength
    when 0...20   then "Very Weak"
    when 20...40  then "Weak"
    when 40...60  then "Good"
    when 60...80  then "Strong"
    else
      "Very Strong"
    end
  end

  def absolute_score
    #@absolute_score ||= 
    additions - deductions
  end

  def additions
    number_of_characters + uppercase_letters + lowercase_letters + numbers + symbols + middle_numbers_or_symbols + requirements
  end
  
  def deductions
    letters_only + numbers_only + repeated_characters + 
      sequential_letters + sequential_numbers + sequential_symbols +
      consecutive_uppercase + consecutive_lowercase + consecutive_numbers
  end
  
# Additions
  def number_of_characters
    password.length * 4
  end
  def uppercase_letters
    n = password.gsub(/[^A-Z]/, '\1').length
    n > 0 ? (length - n) * 2 : 0
  end
  def lowercase_letters
    n = password.gsub(/[^a-z]/, '\1').length
    n > 0 ? (length - n) * 2 : 0
  end
  def numbers
    n = password.gsub(/[^0-9]/, '\1').length
    n < length ? n * 4 : 0
  end
  def symbols
    password.gsub(/[a-zA-Z0-9_]/, '\1').length * 6
  end
  def middle_numbers_or_symbols
    length < 3 ? 0 : password[1...-1].gsub(/[a-zA-Z]/, '\1').length * 2
  end
  def requirements
    if length >= 8
      numbers = password.gsub(/[^0-9]/, '\1').length > 0 ? 1 : 0
      lowercase = password.gsub(/[^a-z]/, '\1').length > 0 ? 1 : 0
      uppercase = password.gsub(/[^A-Z]/, '\1').length > 0 ? 1 : 0
      symbols = password.gsub(/[a-zA-Z0-9_]/, '\1').length > 0 ? 1 : 0
      n = (numbers + lowercase + uppercase + symbols)
      n > 2 ? (n + 1) * 2 : 0 # add 2 for satisfying length
    else
      0
    end
  end
  
# Deductions  
  def letters_only
    n = password.gsub(/[^a-zA-Z]/, '\1').length
    n == length ? n : 0
  end

  def numbers_only
    n = password.gsub(/[^0-9]/, '\1').length
    n == length ? n : 0
  end

  def repeated_characters
    nc = ni = 0
    length.times do |a|
      ch_exists = false
      length.times do |b|
        if a != b && password[a] == password[b]
          ch_exists = true
          ni += (length.to_f / (b - a)).abs
        end
      end
      if ch_exists
        nc += 1
        unique = length - nc;
        ni = unique != 0 ? (ni/unique).ceil : ni.ceil
      end
    end
    ni
  end
  
  def sequential_letters
    sequential LETTERS, password.downcase
  end
  
  def sequential_numbers
    sequential NUMBERS
  end

  def sequential_symbols
    sequential SYMBOLS
  end
  
  def sequential(str, p = password)
    n = 0
    (str.size - 3).times do |i|
      s = str[i..i + 2]
      n += 1 if p.include?( s) || p.include?( s.reverse) 
    end
    n * 3
  end
  
  def consecutive_uppercase
    consecutive /[A-Z]/
  end
  
  def consecutive_lowercase
    consecutive /[a-z]/
  end
  
  def consecutive_numbers
    consecutive /[0-9]/
  end
  
  def consecutive(pattern)
    n = 0
    prev = nil
    password.chars do |c|
      m = c.match(pattern)
      n += 1 if m && prev
      prev = m
    end
    n * 2
  end
    
end
