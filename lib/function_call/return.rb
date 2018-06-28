class FunctionCall
  # Translates return instruction
  class Return < FunctionCall
    def initialize(*args)
      super
      Line.leave_function!
    end

    def to_assembly
      <<~CODE
      @LCL
      D=M
      @R13 // Temporary variable FRAME
      M=D

      @5
      D=A
      @R13
      A=M-D // A register points to FRAME-5
      D=M // D register holds address at FRAME-5
      @R14 // Temporary variable RET
      M=D

      // Set address at ARG to value at SP-1
      @SP
      A=M-1 // A register holds address of stack pointer - 1
      D=M // return value is now in D
      @ARG
      A=M
      M=D

      // SP = ARG+1
      @ARG
      D=M+1
      @SP
      M=D

      // THAT = *(FRAME-1)
      @R13 // FRAME
      A=M-1
      D=M
      @THAT
      M=D

      @R13 // FRAME
      D=M
      @2
      D=D-A
      A=D
      D=M
      @THIS
      M=D

      @R13 // FRAME
      D=M
      @3
      D=D-A
      A=D
      D=M
      @ARG
      M=D

      @R13 // FRAME
      D=M
      @4
      D=D-A
      A=D
      D=M
      @LCL
      M=D

      // Go to return address
      @R14
      A=M
      0;JMP
      CODE
    end
  end
end