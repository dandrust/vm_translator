#!/usr/bin/env ruby

require_relative 'lib/line'
require 'pry'

# Entry point for translator
class VmTranslator
  attr_reader :file_name

  def initialize(file_name)
    @file_name = file_name
    @lines = []
  end

  def parse
    File.open(@file_name, 'r') do |file|
      while (line = file.gets)
        @lines << Line.parse(line, self)
      end
    end
    self
  end

  def write
    File.open @file_name.gsub('vm', 'asm'), 'w' do |file|
      @lines
        .select(&:writable?)
        .each { |code| file.puts code.to_assembly }
    end
    self
  end

  def self.translate(file_path)
    new(file_path)
      .parse
      .write
  end
end

VmTranslator.translate(ARGV[0]) if ARGV[0]
