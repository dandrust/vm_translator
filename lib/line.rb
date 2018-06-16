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
      case verb.to_sym
      when :push      then Instruction::Push
      when :pop       then Instruction::Pop
      when :label     then ProgramFlow::Label
      when :goto      then ProgramFlow::Goto
      when :'if-goto' then ProgramFlow::IfGoto
      when :function  then FunctionCall::Function
      when :call      then FunctionCall::Call
      when :return    then FunctionCall::Return
      else                 Instruction::Arithmetic
      end
    end

    def irrelevant?
      string.empty? || string.nil? || string.match(%r{^//})
    end

    def parse_string
      string.match(/^(?<operation>[\w-]*)\s*(?<segment>\w*)\s*(?<index>\w*)\s*/)
    end
  end
end

require_relative 'instruction'
require_relative 'program_flow'
require_relative 'comment'
