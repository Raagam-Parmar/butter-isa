open Base
open Common.Bits

let fpp_RR inst rs1 rs2 =
  Printf.sprintf "%s\t%s %s"
    inst
    (Register.to_string rs1)
    (Register.to_string rs2)


let fpp_R inst r =
  Printf.sprintf "%s\t%s"
    inst
    (Register.to_string r)


let fpp_I inst imm =
  Printf.sprintf "%s\t%s"
    inst
    (Int.to_string (Bits4.to_int imm))


let pp = function
  | Load (rs1, rs2) -> fpp_RR "load" rs1 rs2
  | Store (rs1, rs2) -> fpp_RR "store" rs1 rs2

  | Lui imm -> fpp_I "lui" imm
  | Lli imm -> fpp_I "lli" imm

  | Move (rs1, rs2) -> fpp_RR "mov" rs1 rs2
  | Add (rs1, rs2) -> fpp_RR "add" rs1 rs2
  | Sub (rs1, rs2) -> fpp_RR "sub" rs1 rs2
  | And (rs1, rs2) -> fpp_RR "and" rs1 rs2
  | Or (rs1, rs2) -> fpp_RR "or" rs1 rs2
  | Not rs1 -> fpp_R "not" rs1

  | Beqz (rs1, rs2) -> fpp_RR "beqz" rs1 rs2
  | Bltz (rs1, rs2) -> fpp_RR "bltz" rs1 rs2
  | Bgtz (rs1, rs2) -> fpp_RR "bgtz" rs1 rs2

  | Jump rs2 -> fpp_R "jump" rs2
  | StPC rs1 -> fpp_R "stpc" rs1

  | DPage rs2 -> fpp_R "dpage" rs2
  | IPage rs2 -> fpp_R "ipage" rs2
