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

class CreateCipherBureauStatistics < ActiveRecord::Migration
  def change
    create_table :cipher_bureau_statistics do |t|
      t.integer :country_code
      t.string  :grammar
      t.string  :name_type
      t.boolean :ascii
      t.integer :length
      t.integer :word_count, :default => 0
    end
    
    add_index :cipher_bureau_statistics, [:grammar, :name_type, :length]                ,  :name => :cipher_bureau_statistics_grammar_name_type_length
    add_index :cipher_bureau_statistics, [:grammar, :length]                            ,  :name => :cipher_bureau_statistics_grammar_length
    add_index :cipher_bureau_statistics, [:country_code, :grammar, :name_type, :length] ,  :name => :cipher_bureau_statistics_country_code_grammar_name_type_length
    add_index :cipher_bureau_statistics, [:country_code, :grammar, :length]             ,  :name => :cipher_bureau_statistics_country_code_grammar_length
  end
end
