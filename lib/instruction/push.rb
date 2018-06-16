class Instruction
  # Translates `push` instructions
  class Push < Instruction
    def initialize(*args)
      @operation, @segment, @index = *args
    end

    def to_assembly
      <<~CODE
      // Start #{operation} #{segment} #{index}
      #{resolve_address}
      @SP            // Put SP in A register
      M=M+1          // Increment SP since we have it in A
      A=M-1          // Put stack address in A register
      M=D            // Write contant to stack
      // End #{operation} #{segment} #{index}
      CODE
    end

    def resolve_address
      case segment.to_sym
      when :constant
        constant_address
      when :pointer, :temp
        base_segment_address
      when :static
        static_address
      else
        generic_address
      end
    end

    def constant_address
      <<~CODE
      @#{index.to_i} // Put contant in A register
      D=A            // Put contant in D register
      CODE
    end

    def base_segment_address
      <<~CODE
      @#{Instruction::SEGMENT_SYMBOLS[segment.to_sym].to_i + index.to_i} // Put contant in A register
      D=M            // Put value at that address in D
      CODE
    end

    def static_address
      <<~CODE
      @#{sanitize_file_name}.#{index}
      D=M     // Address of static var is now in D register
      CODE
    end

    def generic_address
      <<~CODE
      @#{Instruction::SEGMENT_SYMBOLS[segment.to_sym]}
      D=M            // Store base address in D
      @#{index.to_i} // Put index in A register
      A=D+A          // Add index to base address, store in D
      D=M
      CODE
    end
  end
end