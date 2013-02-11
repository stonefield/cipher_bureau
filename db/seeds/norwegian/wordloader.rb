# encoding: utf-8
require 'unicode_utils'

country_code = 47

grammar_map = {
  'prep' =>         'preposition',
  'verb' =>         'verb',
  'adj' =>          'adjective',
  'adv' =>          'adverb',
  'subst' =>        'noun',
  'interj' =>       'interjection',
  'det' =>          'determiner',
  'pron' =>         'pronoun',
  'verbalsubst' =>  'verbalsubst',
  'musikkuttr' =>   'musical',
  'konj' =>         'conjunction',
  'numeral' =>      'numeral',
  'sbu' =>          'subjunctive',
  'adjektiv' =>     'adjective',
  'CLB' =>          'conjunction', # or correlative conjunction
  'nominal' =>      'determiner'
}

loader = CipherBureau::DataLoader.new(:norwegian, 1000)

puts "Loading grammar"
loader.process 'NSF-ordlisten', 'NSF-ordlisten.txt' do |str|
  word, grammar = str.split(' ')
  word = UnicodeUtils.downcase(word)
  CipherBureau::Dictionary.create word: word.chomp, grammar: grammar_map[grammar], country_code: country_code  
end

names_map = {
  'surname' => 'etternavn',
  'boysname' => 'guttenavn',
  'girlsname' => 'jentenavn'
}
loader.chunks = 100
names_map.each do |name_type, file|
  puts "Loading #{name_type}"
  loader.process 'norske-navn', "#{file}.txt" do |name|
    CipherBureau::Dictionary.create word: name, grammar: 'name', name_type: name_type, country_code: country_code
  end
end

puts "Total words loaded: #{loader.words}"