# Singleton factory and prototype class for instructions and program flow lines
class Line
  def sanitize_file_name
    Line.file_name.match(%r{/(?<name>\w*)\.vm})[:name]
  end

  def writable?
    !is_a?(Comment)
  end

  class << self
    attr_reader :file_name, :string

    CODE_CLASSES = {
      push: Instruction::Push,
      pop: Instruction::Pop,
      label: ProgramFlow::Label,
      goto: ProgramFlow::Goto,
      'if-goto': ProgramFlow::IfGoto
    }.freeze

    def parse(string, translator)
      @file_name = translator.file_name
      @string = string.chomp.strip
      generate_code
    end

    private

    def generate_code
      return ::Comment.new(string) if irrelevant?

      _, verb, noun, arg = *parse_string.to_a

      code_class_for(verb).new(verb, noun, arg)
    end

    def code_class_for(verb)
      CODE_CLASSES[verb.to_sym] || Instruction::Arithmetic
    end

    def irrelevant?
      string.empty? || string.nil? || string.match(%r{^//})
    end

    def parse_string
      regex = /^(?<operation>[\w-]*)\s*(?<segment>\w*)\s*(?<index>\w*)\s*/
      string.match(regex)
    end
  end
end

require_relative 'instruction'
require_relative 'program_flow'
require_relative 'comment'
