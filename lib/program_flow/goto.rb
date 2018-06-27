class ProgramFlow
  # Translates `goto` statements
  class Goto < ProgramFlow
    def to_assembly
      <<~CODE
      @#{in_function? ? "#{function}$" : "#{sanitize_file_name}."}#{label}
      0;JMP
      CODE
    end
  end
end
