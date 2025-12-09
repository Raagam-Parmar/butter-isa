open Ast
open Common.Bits

module SymTbl = Map.Make(String)

let is_base = function
  | Load _ | Store _ | Lui _ | Lli _ | Move _ | Add _ | Sub _ | And _ | Or _
  | Not _ | Beqz _ | Bltz _ | Jump _ | StPC _ | DPage _ | IPage _ -> true

  | Li _ | La _ | Bgez _ | Bgtz _ | Blez _ | Bnez _ | Label _ -> false


let expansion_map = function
  | Load _ | Store _ | Lui _ | Lli _ | Move _ | Add _ | Sub _ | And _ | Or _
  | Not _ | Beqz _ | Bltz _ | Jump _ | StPC _ | DPage _ | IPage _ -> 1

  | Li _ | La _ -> 2
  | Bgez _ -> 2
  | Bgtz _ -> 1
  | Blez _ -> 2
  | Bnez _ -> 2
  | Label _ -> 0



let expand instruction  =
  match instruction with
  | Load (rs1, rs2) -> [Load (rs1, rs2)]
  | Store (rs1, rs2) -> [Store (rs1, rs2)]

  | Lui        imm  -> [ Lui        imm  ]
  | Lli        imm  -> [ Lli        imm  ]
  | Li     imm      -> expand_li imm
  | La     lbl      -> expand_la lbl

  | Move (rs1, rs2) -> [ Move (rs1, rs2) ]
  | Add  (rs1 ,rs2) -> [ Add  (rs1, rs2) ]
  | Sub  (rs1, rs2) -> [ Sub  (rs1, rs2) ]
  | And  (rs1, rs2) -> [ And  (rs1, rs2) ]
  | Or   (rs1, rs2) -> [ Or   (rs1, rs2) ]
  | Not   rs1       -> [ Not   rs1       ]

  | Beqz (rs1, rs2) -> [ Beqz (rs1, rs2) ]
  | Bltz (rs1, rs2) -> [ Bltz (rs1, rs2) ]
  | Bgez (rs1, rs2) -> [ Bltz (rs2, rs1) ;
                         Beqz (rs1, rs2) ]
  | Bgtz (rs1, rs2) -> [ Bltz (rs2, rs1) ]
  | Blez (rs1, rs2) -> [ Bltz (rs1, rs2) ;
                         Beqz (rs1, rs2) ]
  | Bnez (rs1, rs2) -> [ Bltz (rs1, rs2) ;
                         Bltz (rs2, rs2) ]

  | Jump       rs2  -> [ Jump       rs2  ]
  | StPC  rs1       -> [ StPC  rs1       ]

  | DPage      rs2  -> [ DPage       rs2 ]
  | IPage      rs2  -> [ IPage       rs2 ]

  | Label lbl ->       [ Label    lbl    ]


(* | Load  of Register.t * Register.t
   | Store of Register.t * Register.t

   | Lui   of 'a
   | Lli   of 'a
   | Li    of 'a (* pseudo-instruction *)
   | La    of 'l (* pseudo-instruction *)

   | Move  of Register.t * Register.t
   | Add   of Register.t * Register.t
   | Sub   of Register.t * Register.t
   | And   of Register.t * Register.t
   | Or    of Register.t * Register.t
   | Not   of Register.t

   | Beqz  of Register.t * Register.t
   | Bltz  of Register.t * Register.t
   | Bgez  of Register.t * Register.t (* pseudo-instruction *)
   | Bgtz  of Register.t * Register.t (* pseudo-instruction *)
   | Blez  of Register.t * Register.t (* pseudo-instruction *)
   | Bnez  of Register.t * Register.t (* pseudo-instruction *)

   | Jump  of Register.t
   | StPC  of Register.t

   | DPage of Register.t
   | IPage of Register.t

   | Label of 'l pseudo-instruction *)

let parse s =
  let lexbuf = Lexing.from_string s in
  let ast = Parser.main Lexer.read lexbuf in
  ast

