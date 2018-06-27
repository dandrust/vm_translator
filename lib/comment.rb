# Instruction placehoder for comments that should not be translated
class Comment < Line
  attr_reader :string
  def initialize(string)
    @string = string
    super
  end
end
