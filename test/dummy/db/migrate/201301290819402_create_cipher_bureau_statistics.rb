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
