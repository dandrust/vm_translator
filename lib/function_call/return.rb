class FunctionCall
  # Translates return instruction
  class Return < FunctionCall
    def initialize(*args)
      super
      Line.leave_function!
    end

    def to_assembly
      
    end
  end
end