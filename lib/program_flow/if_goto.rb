class ProgramFlow
  # Translates `if-goto` statements
  class IfGoto < ProgramFlow
    def to_assembly
      <<~CODE
      @SP
      AM=M-1
      D=M
      @#{in_function? ? "#{function}$" : "#{sanitize_file_name}."}#{label}
      D;JNE
      CODE
    end
  end
end