# Prototype class for goto, if-goto, and label lines
class ProgramFlow < Line
  attr_reader :label, :function

  def initialize(*args)
    _, @label = *args
    @function = Line.function
  end
  
  def in_function?
    !!self.function
  end

end

require_relative 'program_flow/goto'
require_relative 'program_flow/if_goto'
require_relative 'program_flow/label'
