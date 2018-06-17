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
      A=A-D // A register points to FRAME-5
      D=M // D register holds address at FRAME-5
      @R14 // Temporary variable RET
      M=D

      // Set address at ARG to value at SP-1
      @SP
      A=A-1
      D=M // return value is now in D
      @ARG
      A=M
      M=D 

      // SP = ARG+1
      @ARG
      D=M+1
      @SP
      M=D

      @R13 // FRAME
      D+M
      @THAT
      M=D-1

      @R13 // FRAME
      D+M
      @2
      D=D-A
      @THIS
      M=D

      @R13 // FRAME
      D+M
      @3
      D=D-A
      @ARG
      M=D

      @R13 // FRAME
      D+M
      @4
      D=D-A
      @LCL
      M=D

      // Go to return address
      @R14
      0;JMP
      CODE
    end
  end
end