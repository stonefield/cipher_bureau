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

class CipherBureau::StatisticTest < ActiveSupport::TestCase
  
  fixtures :cipher_bureau_statistics
  
  context 'validation' do
    should validate_presence_of :country_code
    should validate_presence_of :grammar
    should validate_presence_of :length
  end
  context 'statistic' do
    setup do
      @word = CipherBureau::Dictionary.new :word => 'gurba', :grammar => 'bullshit', :country_code => '999'
    end
    should 'create counter if it does not exist' do
      assert_difference 'CipherBureau::Statistic.count' do
        CipherBureau::Statistic.register @word
      end
    end
    should 'set initial counter to 1' do
      stat = CipherBureau::Statistic.register @word
      assert_equal 1, stat.word_count
    end
    should 'increase counter if it exists' do
      stat1 = stat2 = nil
      assert_difference 'CipherBureau::Statistic.count' do
        stat1 = CipherBureau::Statistic.register @word
      end
      assert_no_difference 'CipherBureau::Statistic.count' do
        stat2 = CipherBureau::Statistic.register @word
      end
      assert_equal stat1, stat2
      assert_equal 2, stat2.word_count
    end
  end
  
  
  context 'class method' do
    context 'word_count' do
      should 'sum across records' do
        assert_equal 100, CipherBureau::Statistic.word_count
      end
      should 'accepot where clause' do
        assert_equal 40, CipherBureau::Statistic.word_count( :length => 4)
        assert_equal 20, CipherBureau::Statistic.word_count( :length => 4, :ascii => true)
      end
      should 'accept optional length' do
        assert_equal 60, CipherBureau::Statistic.word_count(5, :ascii => false)
        assert_equal 60, CipherBureau::Statistic.word_count(5, :ascii => false)
      end
    end
  end
  
end