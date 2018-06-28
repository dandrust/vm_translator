require_relative 'line'
require_relative 'bootstrap'

# Entry point for translator
class Translator
  include Bootstrap

  attr_reader :directory, :files, :config

  def self.translate(directory)
    new(directory)
      .parse
      .write
  end

  def initialize(directory)
    Dir.chdir(directory)
    @directory = directory
    @lines = []
    @files = Dir.glob('*.vm')
    @config = VmTranslator.configuration
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
      file.puts(bootstrap_bode) if config.apply_bootstrap_code
      @lines.each do |code|
        file.puts(code.to_assembly) if code.writable?
      end
    end
    self
  end
end