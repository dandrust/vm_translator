# Singleton factory and prototype class for instructions and program flow lines
class Line
  attr_reader :file_name

  def initialize(*args)
    @file_name = Line.file_name
  end

  def sanitize_file_name
    file_name.match(/(?<name>\w*)\.vm/)[:name]
  end

  def writable?
    !is_a?(Comment)
  end

  class << self
    attr_reader :file_name, :string, :function

    def parse(string, current_file_name)
      @file_name = current_file_name
      @string = string.chomp.strip
      generate_code
    end

    def enter_function(function_name)
      @function = function_name.to_sym
    end

    def leave_function!
      @function = nil
    end

    private

    def generate_code
      return ::Comment.new(string) if irrelevant?

      _, verb, noun, arg = *parse_string.to_a

      code_class_for(verb).new(verb, noun, arg)
    end

    def code_class_for(verb)
      case verb.to_sym
      when program_flow?  then program_flow(verb)
      when function_call? then function_call(verb)
      else                     instruction(verb)
      end
    end

    def program_flow?
      ->(verb) { %i[label goto if-goto].include?(verb.to_sym) }
    end

    def function_call?
      ->(verb) { %i[function call return].include?(verb.to_sym) }
    end

    def program_flow(verb)
      case verb.to_sym
      when :goto      then ProgramFlow::Goto
      when :'if-goto' then ProgramFlow::IfGoto
      when :label     then ProgramFlow::Label
      end
    end

    def function_call(verb)
      case verb.to_sym
      when :function  then FunctionCall::Function
      when :call      then FunctionCall::Call
      when :return    then FunctionCall::Return
      end
    end

    def instruction(verb)
      case verb.to_sym
      when :push      then Instruction::Push
      when :pop       then Instruction::Pop
      else                 Instruction::Arithmetic
      end
    end

    def irrelevant?
      string.empty? || string.nil? || string.match(%r{^//})
    end

    def parse_string
      string.match(/^(?<operation>[\w-]*)\s*(?<segment>[\w\.:]*)\s*(?<index>\w*)\s*/)
    end
  end
end

require_relative 'comment'
require_relative 'instruction'
require_relative 'function_call'
require_relative 'program_flow'
