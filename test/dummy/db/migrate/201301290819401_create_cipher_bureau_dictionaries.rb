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
