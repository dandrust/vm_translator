class FunctionCall
  # Translates function declaration
  class Function < FunctionCall
    def initialize(*args)
      super
      Line.enter_function(@function_name)
    end

    def to_assembly
      <<~CODE
      (#{function_name})
      // Load argument size to R13
      @#{argument_size || 0}
      D=A
      @END
      D;JEQ // Jump to end if no arguments exist
      @R13 // This is general purpose register for vm implementation
      M=D
      // Beginning of loop
      (CLEAR_LCL)
      // business
      #{Line.parse('push constant 0', sanitize_file_name).to_assembly}
      // Conditional jump if argument size counter is greater than zero
      @R13 // counter stored here
      M=M-1 // decrement counter
      D=M  // load counter into D register
      @CLEAR_LCL // Load jump address
      D;JGT // Since we're counting down, jump to the beginning of the loop if it's greater than zero still
      (END)
      // End of loop
      CODE
    end
  end
end
