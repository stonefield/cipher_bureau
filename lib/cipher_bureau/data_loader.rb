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

require 'open-uri'

module CipherBureau
  class DataLoader
    attr_reader :words, :language
    attr_accessor :chunks
    
    def initialize(language, chunks = 100, words = 0, verbose = true)
      @language, @chunks, @words, @verbose = language, chunks, words, verbose
    end

    def reader(filename)
      Fiber.new do
        puts "Reading file #{filename}" if @verbose
        open(filename).readlines.each do |str|
          Fiber.yield str
        end
        puts "\r#{@words}" if @verbose
        nil
      end
    end

    def writer(fiber, &block)
      str = nil
      begin
        chunks.times do
          ActiveRecord::Base.transaction do
            break unless str = fiber.resume
            yield str.chomp
            @words += 1
          end
          return unless str
        end
        print "\r#{@words}" if @verbose
      end while str
    end
    
    def process(*directories_and_filename, &block)
      filename = ([CipherBureau.language_repository, language.to_s] + directories_and_filename).join('/')
      writer(reader(filename), &block)
    end
  end
end