class ProgramFlow
  # Translates `goto` statements
  class Goto < ProgramFlow
    def to_assembly
      <<~CODE
      @#{sanitize_file_name}.#{label}
      0;JMP
      CODE
    end
  end
end
