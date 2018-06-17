# Translates function call lines
class FunctionCall < Line
  attr_reader :operation, :function_name, :argument_size

  def initialize(*args)
    @operation, @function_name, @argument_size = *args
  end
end

require_relative 'function_call/call'
require_relative 'function_call/function'
require_relative 'function_call/return'