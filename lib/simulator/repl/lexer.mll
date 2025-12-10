{
  open Parser
  open Butter_isa
}

let space        = [' ' '\t']
let spaces       = space+
let newline      = '\r' | '\n' | "\r\n"

let ignore       = space | newline

let digit        = ['0'-'9']
let int          = digit+

(* let lower_char   = ['a'-'z']
let upper_char   = ['A'-'Z']

let lbl_misc     = '_'
let lbl_char     = lower_char | upper_char | lbl_misc
let label        = lbl_char+ *)

rule read =
  parse
  | eof         { EOF }

  | "step"      { STEP }

  | "inst"      { INST }
  | "mem"       { MEM  }

  | "help"      { HELP }
  | "quit"      { QUIT }

  | "r0"        { REG (Register.R0) }
  | "r1"        { REG (Register.R1) }
  | "r2"        { REG (Register.R2) }
  | "r3"        { REG (Register.R3) }

  | int         { INT (int_of_string (Lexing.lexeme lexbuf)) }

  | ignore      { read lexbuf }
