# encoding: utf-8
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

require 'test_helper'

class CipherBureau::DictionaryTest < ActiveSupport::TestCase
  fixtures :all
  
  context 'validation' do
    should validate_presence_of :word
    should validate_presence_of :grammar
    should validate_presence_of :country_code
  end
  context 'saving' do
    setup do
      @word = CipherBureau::Dictionary.new :word => 'gurba', :grammar => 'bullshit', :country_code => '999'
    end
    should 'be valid' do
      assert @word.valid?, "Test record was invalid"
    end
    should 'set length' do
      @word.save!
      assert_equal 5, @word.length
    end
    should 'set ascii' do
      @word.word = 'heihåpp'
      @word.save!
      assert !@word.ascii
    end
    should 'register statistics' do
      CipherBureau::Statistic.expects(:register).with(@word)
      @word.save
    end
  end
  
  context 'class method' do
    context 'random' do
      should 'check statistics before fetching data' do
        criteria = {:country_code => 47, :grammar => 'noun'}
        CipherBureau::Statistic.expects(:word_count).with(criteria.merge(:length => 4)).returns(3)
        CipherBureau::Dictionary.expects(:randomized_offset).with(3).returns(1)
        assert_equal 'kjel', CipherBureau::Dictionary.random(4, criteria)
      end
      should 'support camelize' do
        CipherBureau::Dictionary.expects(:fetch_random_word).with(:length => 4).returns(stub(:word => 'halo'))
        assert_equal 'Halo', CipherBureau::Dictionary.random(4, :camelize => true)
        CipherBureau::Dictionary.expects(:fetch_random_word).with(:length => 4).returns(stub(:word => 'øyne'))
        assert_equal 'Øyne', CipherBureau::Dictionary.random(4, :camelize => true)
      end
    end
  end
  
  
end
