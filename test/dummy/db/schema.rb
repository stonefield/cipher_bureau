# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 201301290819402) do

  create_table "cipher_bureau_dictionaries", :force => true do |t|
    t.string  "word"
    t.integer "length"
    t.string  "grammar"
    t.string  "name_type"
    t.integer "country_code"
    t.boolean "ascii"
  end

  add_index "cipher_bureau_dictionaries", ["country_code", "length", "grammar", "name_type"], :name => "cipher_bureau_dicts_cc_lengramtype"
  add_index "cipher_bureau_dictionaries", ["country_code", "length", "name_type"], :name => "cipher_bureau_dicts_cc_length_name_type"
  add_index "cipher_bureau_dictionaries", ["country_code", "word", "grammar", "name_type"], :name => "cipher_bureau_dicts_unique", :unique => true
  add_index "cipher_bureau_dictionaries", ["length", "grammar", "name_type"], :name => "cipher_bureau_dicts_lengramnametype"
  add_index "cipher_bureau_dictionaries", ["length", "name_type"], :name => "cipher_bureau_dicts_lennametype"
  add_index "cipher_bureau_dictionaries", ["word", "grammar", "name_type"], :name => "cipher_bureau_dicts_wordgranname"

  create_table "cipher_bureau_statistics", :force => true do |t|
    t.integer "country_code"
    t.string  "grammar"
    t.string  "name_type"
    t.boolean "ascii"
    t.integer "length"
    t.integer "word_count",   :default => 0
  end

  add_index "cipher_bureau_statistics", ["country_code", "grammar", "length"], :name => "cipher_bureau_statistics_country_code_grammar_length"
  add_index "cipher_bureau_statistics", ["country_code", "grammar", "name_type", "length"], :name => "cipher_bureau_statistics_country_code_grammar_name_type_length"
  add_index "cipher_bureau_statistics", ["grammar", "length"], :name => "cipher_bureau_statistics_grammar_length"
  add_index "cipher_bureau_statistics", ["grammar", "name_type", "length"], :name => "cipher_bureau_statistics_grammar_name_type_length"

end
