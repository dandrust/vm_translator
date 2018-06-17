class ProgramFlow
  # Translates labels
  class Label < ProgramFlow
    def to_assembly
      <<~CODE
      (#{sanitize_file_name}.#{"#{function}$" if in_function?}#{label})
      CODE
    end
  end
end
