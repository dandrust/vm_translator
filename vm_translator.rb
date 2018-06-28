#!/usr/bin/env ruby

# Configuration module
module VmTranslator
  def self.setup(options = {})
    @configuration ||= Configuration.new
    if block_given?
      yield @configuration
    else
      options.each do |k, v|
        @configuration.send(:"#{k}=", v)
      end
    end
  end

  def self.configuration
    @configuration
  end

  # Configuration class
  class Configuration
    attr_accessor :apply_bootstrap_code

    def initialize
      @apply_bootstrap_code = true
    end
  end
  setup
end

require 'pry'
require_relative 'lib/translator'