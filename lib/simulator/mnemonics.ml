open Butter_isa.Isa
open Butter_isa.Register
open Common.Modulo

let r0 = R0
let r1 = R1
let r2 = R2
let r3 = R3


let load rs1 rs2 = Load (rs1, rs2)
let store rs1 rs2 = Store (rs1, rs2)

let lli n = Lli (Mod16.create n)
let lui n = Lui (Mod16.create n)

let mov rs1 rs2 = Move (rs1, rs2)

let add rs1 rs2 = Add (rs1, rs2)
let sub rs1 rs2 = Sub (rs1, rs2)
let annd rs1 rs2 = And (rs1, rs2)
let not rs1 = Not rs1

let beqz rs1 rs2 = Beqz (rs1, rs2)
let bltz rs1 rs2 = Bltz (rs1, rs2)
let jump rs2 = Jump rs2

let stpc rs1 = StPC rs1

let dpage rs1 = DPage rs1
let ipage rs1 = IPage rs1

(** Load arbitrary 8-bit number *)
let li n =
  let n' = Mod256.create n in
  let n_lo = Mod256.to_int n' in
  let n_hi = Int.shift_right (Mod256.to_int n') 4 in
  [|
    lli n_lo;
    lui n_hi
  |]

(** First half of [li n] *)
let li_lo n =
  let n' = Mod256.create n in
  let n_lo = Mod256.to_int n' in
  lli n_lo

(** Second hald of [li n] *)
let li_hi n =
  let n' = Mod256.create n in
  let n_hi = Int.shift_right (Mod256.to_int n') 4 in
  lui n_hi
