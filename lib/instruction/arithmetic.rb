class Instruction
  # Translates arithmetic instructions
  class Arithmetic < Instruction
    class << self
      attr_accessor :jump_counter
    end

    OPERATION_SYMBOLS = {
      add: '+',
      sub: '-',
      neg: '-',
      and: '&',
      or:  '|',
      not: '!'
    }.freeze

    JUMP_CONDITIONS = {
      eq: 'JEQ',
      lt: 'JLT',
      gt: 'JGT'
    }.freeze

    @jump_counter = 0

    def initialize(*args)
      @operation, = *args
      super
    end

    def to_assembly
      case operation.to_sym
      when :add, :sub, :and, :or
        binary_operation
      when :neg, :not
        unary_operation
      when :eq, :gt, :lt
        boolean_operation
      end
    end

    private

    def binary_operation
      <<~CODE
      // Start #{operation}
      @SP    // Put SP in A register
      AM=M-1 // Put address of 1st argument in A, decrement SP
      D=M    // Put 1st argument in D
      @SP
      A=M-1  // Put address of 2nd argument in A
      M=M#{operation_symbol}D  // Computer, write result to M
      // End #{operation}
      CODE
    end

    def unary_operation
      <<~CODE
      // Start #{operation}
      @SP    // Put SP in A register
      A=M-1  // Put SP value in A and D registers
      M=#{operation_symbol}M    // Computer, write result to M
      // End #{operation}"
      CODE
    end

    def boolean_operation
      Arithmetic.jump_counter += 1
      <<~CODE
      // Start #{operation}
      // Decrement SP
      @SP
      AM=M-1
      // Store 1st argument
      D=M
      // Decrement SP
      @SP
      AM=M-1
      // Compute difference, store in D register
      D=M-D
      // Conditional jump
      @TRUE#{Arithmetic.jump_counter}
      D;#{jump_condition}

      // False condition: Set D=0 for later storage
      D=0
      @END#{Arithmetic.jump_counter}
      0;JMP

      // True condition: Set D=-1 for later storage
      (TRUE#{Arithmetic.jump_counter})
      D=-1

      // Wrap Up: Write result and increment SP
      (END#{Arithmetic.jump_counter})
      @SP
      M=M+1  // Increment SP since we have it in A
      A=M-1  // Set A to what SP was before inc.
      M=D
      // End #{operation}
      CODE
    end

    def operation_symbol
      OPERATION_SYMBOLS[operation.to_sym]
    end

    def jump_condition
      JUMP_CONDITIONS[operation.to_sym]
    end
  end
end
