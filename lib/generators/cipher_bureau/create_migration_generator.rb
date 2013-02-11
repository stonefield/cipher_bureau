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

module CipherBureau
  class CreateMigrationGenerator < Rails::Generators::Base
    include Rails::Generators::Migration
    source_root File.expand_path('../../templates', __FILE__)
  
    def self.next_migration_number(path)
      @v ||= 0
      @v += 1
      Time.now.utc.strftime("%Y%m%d%H%M%S") + "#{@v}"
    end
    
    desc "Creates a migration file for the cipher_bureau_dictionaries tables"
    def create_table_file
      migration_template "create_cipher_bureau_dictionaries.rb", "db/migrate/create_cipher_bureau_dictionaries.rb"
      migration_template "create_cipher_bureau_statistics.rb", "db/migrate/create_cipher_bureau_statistics.rb"
    end  
  end
end