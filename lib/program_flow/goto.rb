class ProgramFlow
  # Translates `goto` statements
  class Goto < ProgramFlow
    def to_assembly
      <<~CODE
      @#{sanitize_file_name}.#{"#{function}$" if in_function?}#{label}
      0;JMP
      CODE
    end
  end
end
