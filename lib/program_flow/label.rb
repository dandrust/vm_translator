class ProgramFlow
  # Translates labels
  class Label < ProgramFlow
    def to_assembly
      <<~CODE
      (#{in_function? ? "#{function}$" : "#{sanitize_file_name}."}#{label})
      CODE
    end
  end
end
