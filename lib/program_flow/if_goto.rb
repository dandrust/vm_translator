class ProgramFlow
  # Translates `if-goto` statements
  class IfGoto < ProgramFlow
    def to_assembly
      <<~CODE
      @SP
      AM=M-1
      D=M
      @#{sanitize_file_name}.#{"#{function}$" if in_function?}#{label}
      D;JNE
      CODE
    end
  end
end