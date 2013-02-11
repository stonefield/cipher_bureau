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

class CreateCipherBureauDictionaries < ActiveRecord::Migration
  def change
    create_table :cipher_bureau_dictionaries do |t|
      t.string  :word
      t.integer :length
      t.string  :grammar
      t.string  :name_type
      t.integer :country_code
      t.boolean :ascii
    end
    
    add_index :cipher_bureau_dictionaries, [:word, :grammar, :name_type], :name => :cipher_bureau_dicts_wordgranname
    add_index :cipher_bureau_dictionaries, [:length, :grammar, :name_type], :name => :cipher_bureau_dicts_lengramnametype
    add_index :cipher_bureau_dictionaries, [:length, :name_type], :name => :cipher_bureau_dicts_lennametype
    add_index :cipher_bureau_dictionaries, [:country_code, :word, :grammar, :name_type], :unique => true, :name => :cipher_bureau_dicts_unique
    add_index :cipher_bureau_dictionaries, [:country_code, :length, :grammar, :name_type], :name => :cipher_bureau_dicts_cc_lengramtype
    add_index :cipher_bureau_dictionaries, [:country_code, :length, :name_type], :name => :cipher_bureau_dicts_cc_length_name_type
  end
end
