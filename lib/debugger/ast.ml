open Butter_isa

type command =
  | Step of int

  | Show_instruction
  | Show_program
  | Show_regfile
  | Show_reg of Register.t
  | Show_mem
  | Show_mem_addr of int

  | Show_dpage
  | Show_ipage

  | Help
  | Quit
