# Module including bootstrap code
module Bootstrap
  def bootstrap_bode
    <<~CODE
    @256 // Set SP to 256
    D=A
    @SP
    M=D
    @Sys.init // Call Sys.init
    0;JMP
    CODE
  end
end