class FunctionCall
  # Translates function declaration
  class Function < FunctionCall
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
      push 0 
      // Conditional jump if argument size counter is greater than zero
      @R13 // counter stored here
      DM=M-1 // load counter into D register
      @CLEAR_LCL // Load jump address
      D;JGT // Since we're counting down, jump to the beginning of the loop if it's greater than zero still
      (END)
      // End of loop
      CODE
    end
  end
end