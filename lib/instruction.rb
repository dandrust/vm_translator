# Singleton factory for arithmetic, pop, and push instructions
class Instruction < Line
  attr_reader :operation, :segment, :index

  SEGMENT_SYMBOLS = {
    local: 'LCL',
    argument: 'ARG',
    this: 'THIS',
    that: 'THAT',
    pointer: '3',
    temp: '5'
  }.freeze

  def base_address?
    !%i[pointer temp].include?(segment)
  end

  def segment_address
    case segment.to_sym
    when :constant
      index
    when :pointer, :temp
      SEGMENT_SYMBOLS[segment.to_sym] + index
    else
      SEGMENT_SYMBOLS[segment.to_sym]
    end
  end
end

require_relative 'instruction/push'
require_relative 'instruction/pop'
require_relative 'instruction/arithmetic'
