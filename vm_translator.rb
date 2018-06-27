#!/usr/bin/env ruby

require_relative 'lib/line'
require 'pry'

# Entry point for translator
class VmTranslator
  attr_reader :directory, :files

  def initialize(directory)
    Dir.chdir(directory)
    @directory = directory
    @lines = []
    @files = Dir.glob('*.vm')
    binding.pry
  end

  def parse
    files.each do |file_name|
      File.open(file_name, 'r') do |file|
        while (line = file.gets)
          @lines << Line.parse(line, file_name)
        end
      end
    end
    self
  end

  def write
    file_name = "#{directory.split('/').last}.asm"
    File.open(file_name, 'w') do |file|
      @lines.each do |code|
        file.puts(code.to_assembly) if code.writable?
      end
    end
    self
  end

  def self.translate(directory)
    new(directory)
      .parse
      .write
  end
end

# VmTranslator.translate(ARGV[0]) if ARGV[0]
