open Butter_isa

type command =
  | Step of int

  | Show_instruction
  | Show_reg of Register.t
  | Show_mem of int

  | Help
  | Quit
