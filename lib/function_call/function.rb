class FunctionCall
  # Translates function declaration
  class Function < FunctionCall
    class << self
      attr_accessor :call_counter
      
      def increment_call_counter
        @call_counter += 1
      end
    end

    @call_counter = 0
    
    attr_accessor :instance_call_counter

    def initialize(*args)
      super
      Line.enter_function(@function_name)
    end
    
    def call_counter
      @instance_call_counter ||= Function.increment_call_counter
    end

    def to_assembly
      <<~CODE
      (#{function_name})
      // Load argument size to R13
      @#{argument_size || 0}
      D=A
      @END#{call_counter}
      D;JEQ // Jump to end if no arguments exist
      @R13 // This is general purpose register for vm implementation
      M=D
      // Beginning of loop
      (CLEAR_LCL#{call_counter})
      // business
      #{Line.parse('push constant 0', sanitize_file_name).to_assembly}
      // Conditional jump if argument size counter is greater than zero
      @R13 // counter stored here
      M=M-1 // decrement counter
      D=M  // load counter into D register
      @CLEAR_LCL#{call_counter} // Load jump address
      D;JGT // Since we're counting down, jump to the beginning of the loop if it's greater than zero still
      (END#{call_counter})
      // End of loop
      CODE
    end
  end
end
