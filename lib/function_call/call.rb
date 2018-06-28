class FunctionCall
  # Translates call instruction
  class Call < FunctionCall
    class << self
      attr_accessor :return_counter
    end

    @return_counter = 0

    def to_assembly
      Call.return_counter += 1
      <<~CODE
      // Push return address to the stack
      @RETURN#{Call.return_counter} // Load return address to A
      D=A            // Store in D
      @SP            // Put SP in A register
      M=M+1          // Increment SP since we have it in A
      A=M-1          // Put stack address in A register
      M=D            // Write contant to stack

      #{push_segment_pointer_to_stack(:LCL)}
      #{push_segment_pointer_to_stack(:ARG)}
      #{push_segment_pointer_to_stack(:THIS)}
      #{push_segment_pointer_to_stack(:THAT)}

      // Set ARG back up the stack
      @5
      D=A
      @#{argument_size}
      D=D+A
      @SP
      D=M-D
      @ARG
      M=D

      // Set LCL to SP
      @SP
      D=M
      @LCL
      M=D

      // Jump to function
      @#{function_name}
      0;JMP

      // Return address -- execution should pick up here
      (RETURN#{Call.return_counter})
      CODE
    end

    def push_segment_pointer_to_stack(segment_pointer)
      <<~CODE
      @#{segment_pointer}
      D=M            // Store in D
      @SP            // Put SP in A register
      M=M+1          // Increment SP since we have it in A
      A=M-1          // Put stack address in A register
      M=D            // Write contant to stack
      CODE
    end
  end
end