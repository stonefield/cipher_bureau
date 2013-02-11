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

class CipherBureau::PasswordTest < ActiveSupport::TestCase
  fixtures :all
  
  setup do
    CipherBureau.default_memorable_options = {}
  end
  
  context 'the interface' do
    context 'memorable' do
      should 'generate correct length' do
        @pwd = CipherBureau::Password.memorable(:length => 10)
        assert_equal 10, @pwd.length
      end
      should 'have a default option' do
      end
      should 'support grammar selection' do
        @pwd = CipherBureau::Password.memorable(:length => 10)
        @meter = CipherBureau::PasswordMeter.new(@pwd)
      end
      should 'support camelize option' do
        @pwd = CipherBureau::Password.memorable(:length => 10, :camelize => true)
        assert_equal @pwd[0].upcase, @pwd[0]
        assert_equal @pwd[6].upcase, @pwd[6]
      end
      should 'support middle_numbers option' do
        CipherBureau::Dictionary.expects(:random).twice.with(4, {}).returns('abcd','efgh')
        @pwd = CipherBureau::Password.memorable(:length => 10, :middle_numbers => true)
        assert @pwd.match( /^\w{4,4}\d{2,2}\w{4,4}$/)
      end
      should 'embed numbers and symbols in middle' do
        @pwd = CipherBureau::Password.memorable(:length => 10)
        @meter = CipherBureau::PasswordMeter.new(@pwd)
        assert @meter.middle_numbers_or_symbols > 2
      end
      
      context 'scope' do
        context 'with default values' do
          setup do            
            CipherBureau.default_memorable_options = {
              :length => 10,
              :country_code => 47,
              :ascii => false,
              :grammar => 'name',
              :name_type => 'girlsname'
            } 
          end
          should 'initialize with them' do
            @pwd = CipherBureau::Password.new :length => 10
            assert_equal ({:country_code => 47, :ascii => false, :grammar => 'name', :name_type => 'girlsname'}), @pwd.send(:scope)            
          end
          should 'override, by setting initializer' do
            opts = {:length => 8, :country_code => 44, :ascii => true, :grammar => 'noun'}
            @pwd = CipherBureau::Password.new opts
            opts.delete(:length)
            assert_equal opts, @pwd.send(:scope)
          end
        end
      end
    end
    context 'letters_and_numbers' do
      should 'contain only letters and numbers' do
        10.times do
          assert_match /^[A-Za-z0-9]{12,12}$/, CipherBureau::Password.letters_and_numbers(:length => 12)
        end
      end
    end
    context 'numbers_only' do
      should 'contain only numbers only' do
        10.times do
          assert_match /^[0-9]{10,10}$/, CipherBureau::Password.numbers_only(:length => 10)
        end
      end
    end
    context 'random' do
      should 'contain any random character' do
        50.times do
          illegal = CipherBureau::Password.random(1, :length => 12).bytes.select { |b| b < 32 || b > 126 }
          assert_equal 0, illegal.size
        end
      end
      should 'generate the correct length' do
        pwd = CipherBureau::Password.random(1, :length => 14)
        assert_equal 14, pwd.length
      end
      should 'really be random' do
        assert_not_equal CipherBureau::Password.random(1, :length => 14), CipherBureau::Password.random(1, :length => 14)
      end
    end
    context 'fips-181' do
      # http://www.itl.nist.gov/fipspubs/fip181.htm
      should 'never be used' do
        assert_raises NoMethodError do
          pwd = CipherBureau::Password.fips_181(1, :length => 14)
        end
      end
    end
    context 'strength' do
      should 'delegate to PasswordMeter' do
        CipherBureau::PasswordMeter.expects(:strength).with('abcde').returns(1)
        assert_equal 1, CipherBureau::Password.strength('abcde')
      end
    end
  end

  context 'initializing' do
    should 'validate length' do
      assert_raises ArgumentError do
        pwd = CipherBureau::Password.new
      end
    end
    should 'set options' do
      pwd = CipherBureau::Password.new({:length => 12, :country_code => 99})
      assert_equal 12, pwd.length
      assert_equal ({:country_code => 99}), pwd.options
    end
    should 'set defaults' do
      CipherBureau.default_memorable_options = {
        :length => 12,
        :country_code => 98
      }
      pwd = CipherBureau::Password.new
      assert_equal 12, pwd.length
      assert_equal ({:country_code => 98}), pwd.options
    end
  end
  
  context 'collecting and enumerating' do
    context 'single record' do
      should 'return sigle object' do
        assert CipherBureau::Password.random(1, :length => 10).is_a?(String)
        assert CipherBureau::Password.random(:length => 10).is_a?(String)
      end
      should 'have the abilty to include strength' do
        assert CipherBureau::Password.random(:length => 10, :strength => true).is_a?(Array)
        CipherBureau::Password.expects(:strength).returns(10)
        CipherBureau::Password.any_instance.expects(:random).returns('abcdefgh')
        assert_equal ['abcdefgh', 10], CipherBureau::Password.random(:length => 10, :strength => true)
      end
    end
    context 'multiple records' do
      should 'return array' do
        assert CipherBureau::Password.random(2, :length => 10).is_a?(Array)
        assert_equal 2, CipherBureau::Password.random(2, :length => 10).size
        assert_equal 3, CipherBureau::Password.random(3, :length => 10).size
      end
      should 'have the abilty to include strength' do
        CipherBureau::Password.expects(:strength).twice.returns(10, 5)
        CipherBureau::Password.any_instance.expects(:random).twice.returns('abcdefgh', 'jklmno')
        assert_equal [['abcdefgh', 10], ['jklmno', 5]], CipherBureau::Password.random(2, :length => 10, :strength => true)
      end
    end
    context 'hash option' do
      should 'return hash' do
        assert CipherBureau::Password.random(:length => 10, :strength => true).is_a?(Array)
        CipherBureau::Password.stubs(:strength).returns(10)
        CipherBureau::Password.any_instance.stubs(:random).returns('abcdefgh')
        expected = {:password => 'abcdefgh', :strength => 10}
        assert_equal expected, CipherBureau::Password.random(:length => 10, :strength => true, :as => :hash)
        assert_equal [expected, expected], CipherBureau::Password.random(2, :length => 10, :strength => true, :as => :hash)
      end
    end
  end
end
