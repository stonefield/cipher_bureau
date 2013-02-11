# CipherBureau

### CipherBureau is a simple gem for password generation

Sometimes you need to generate passwords in your application.
This gem does exactly that. It also has the ability to measure the strength of passwords.
In addition it contains a dictionary for creating ```memorable``` passwords. Currently the dictionary is only in Norwegian, but you can easily load dictionaries yourself. See separate explanation on how to load dictionaries, setting up defaults etc.


# Install and Setup

Install the gem

    gem install cipher_bureau
    
Or, in your Gemfile

    gem 'cipher_bureau'


## Generating migration and loading dictionary

If you want to use the ```memorable method```, you will need to create a couple of tables for holding the dictionary.
CipherBureau includes two generators, one for generating the migration, and one for loading the dictionary.

Generate the migration:

    rails generate cipher_bureau:create_migration
    
Load the data

    rails generate cipher_bureau:load_data
    
Loading the data will take some time as there are more than 600,000 words, including grammar and names.

# Using the password interface

## Basic interface

Generate a password, using random as an example

```Ruby
    # Generate a single random password with length 10 characters
    CipherBureau::Password.random(:length => 10)
     => "ZnipfcIByq" 
    
    # Generate two random passwords with length 10 characters
    CipherBureau::Password.random(2, :length => 10)
     => ["4X^gb1}oLP", "g%JJJ:Y`O."] 
    
    # Generate a random password and measure its strength
    CipherBureau::Password.random(:length => 10, :strength => true)
     => ["]KF|O4vANP", 90] 
    
    # Generate two random passwords and measure their strength
    CipherBureau::Password.random(2, :length => 10, :strength => true)
     => [[")1^flZvQ^4", 100], ["^DGAf83B`s", 98]]
```

## Configuring default password length

If you want you can configure the default password length

```Ruby
  # Set deault length to 10 characters
  CipherBureau.password_length = 10
```

## Basic methods

### Password generation methods

You can use the same parameters for all password functions, except memorable which takes more parameters

```Ruby
  CipherBureau::Password.random
   => "dv$w1eD<5T" 
   
  CipherBureau::Password.letters_and_numbers
   => "qoQIfSrElc" 
   
  CipherBureau::Password.numbers_only
   => "6924908575" 
   
  CipherBureau::Password.symbols_and_numbers
   => "<~%2`!-452" 
   
  CipherBureau::Password.memorable
   => "acti)}flik"
```

The memorable password emphasize on generating passwords with symbols and numbers in the middle, as this ranks higher in security.

The memorable method accepts more arguments:

* ```:country_code``` - a numerical value of country_code, e.g. Norway 47
* ```:ascii``` - true of false. Use false to get words outside 7-bits range, such as nordic characters
* ```:camelize``` - true. Only names has first letter capitalized
* ```:grammar``` - legal values are: 'adjective','adverb','conjunction','determiner','interjection','name','noun',
           'musical','numeral','preposition','pronoun','subjunctive','verb','verbalsubst',
* ```:name_tupe``` - if grammar is specified, you can optionally specify: 'boysname','girlsname', 'surname'


Example:

```Ruby
  CipherBureau::Password.memorable(:length => 12, :grammar => 'name', :name_type => 'girlsname')
   => "Hedda[)*Turi"

  CipherBureau::Password.memorable(:length => 12, :grammar => 'noun', :camelize => true)
    => "Aktor2]%Hott" 
```

### Measuring strength of passwords

The PasswordMeter module is a ruby implementation of the javascript algorithm found at http://www.passwordmeter.com
It will return a range from 0 to 100 depending on the complexity of the password.

Examples:

```Ruby
  CipherBureau::PasswordMeter.strength('aaaaaaaa')
   => 0 
  CipherBureau::PasswordMeter.strength('abcdaaa1')
   => 15
  CipherBureau::PasswordMeter.strength('<~%2`!-452')
   => 100 
  CipherBureau::PasswordMeter.strength('Aktor2]%Hott')
   => 97 
  CipherBureau::PasswordMeter.strength('test123')
   => 36 
```


# Configuring defaults

You can configure defaults for passwrd_length and memorable passwords by placing a file in your initializers directory:

```Ruby
  # config/initializers/cipher_bureau.rb
  CipherBureau.configure do |config|
    config.password_length = 10
    config.default_memorable_options = {
      country_code: 47,
      camelize:     true,
      grammar:      'name'
    }
  end
```

# Loading your own dictionary

See the file db/seeds/norwegian/wordloader.rb

This file loads the Norwegian wordlist and Norwegian names into the database. It explains how to load grammars and names into the database.
It is recommended to use the same facilities as that source is using.
CipherBureau::DataLoader is loading data in chunked transactions.

The default repository for dictionaries is located on http://dictionaries.cipher-bureau.net
You can control the location of the dictionaries by setting the configuration ```language_repository```.
