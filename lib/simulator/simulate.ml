open Butter_isa.Base
open Common.Bits

exception PCOutOfBounds


type 'a state =
  { rom: instruction Ram.t;
    length: int;
    ram: 'a Ram.t;
    regfile: 'a Regfile.t;
    pc: 'a;
    dpage: 'a;
    ipage: 'a
  }


let step state =
  let rom = state.rom in
  let length = state.length in
  let ram = state.ram in
  let regfile = state.regfile in
  let pc = state.pc in
  let int_pc = Bits8.to_int pc in

  let () = if int_pc >= length then raise PCOutOfBounds else () in

  let inst = Ram.read rom int_pc in

  match inst with
  | Load (rs1, rs2) ->
    let vrs2 = Regfile.read regfile rs2 in
    let addr = Bits8.to_int vrs2 in
    let data = Ram.read ram addr in
    let () = Regfile.write regfile rs1 data in
    { state with pc = Bits8.succ pc }

  | Store (rs1, rs2) ->
    let vrs2 = Regfile.read regfile rs2 in
    let addr = Bits8.to_int vrs2 in
    let vrs1 = Regfile.read regfile rs1 in
    let () = Ram.write ram addr vrs1 in
    { state with pc = Bits8.succ pc }

  | Lui imm4 ->
    let imm8 =
      Bits8.from_int
        (Int.shift_left (Bits4.to_int imm4) 4)
    in
    let vr0_old = Regfile.read regfile R0 in
    let vr0_new = Bits8.logor imm8 vr0_old in
    let () = Regfile.write regfile R0 vr0_new in
    { state with pc = Bits8.succ pc }

  | Lli imm4 ->
    let imm8 =
      Bits8.from_int
        (Bits4.to_int imm4)
    in
    let () = Regfile.write regfile R0 imm8 in
    { state with pc = Bits8.succ pc }

  | Move (rs1, rs2) ->
    let vrs2 = Regfile.read regfile rs2 in
    let () = Regfile.write regfile rs1 vrs2 in
    { state with pc = Bits8.succ pc }

  | Add (rs1, rs2) ->
    let vrs1 = Regfile.read regfile rs1 in
    let vrs2 = Regfile.read regfile rs2 in
    let vsum = Bits8.add vrs1 vrs2 in
    let () = Regfile.write regfile rs1 vsum in
    { state with pc = Bits8.succ pc }

  | Sub (rs1, rs2) ->
    let vrs1 = Regfile.read regfile rs1 in
    let vrs2 = Regfile.read regfile rs2 in
    let vdiff = Bits8.sub vrs1 vrs2 in
    let () = Regfile.write regfile rs1 vdiff in
    { state with pc = Bits8.succ pc }

  | And (rs1, rs2) ->
    let vrs1 = Regfile.read regfile rs1 in
    let vrs2 = Regfile.read regfile rs2 in
    let vand = Bits8.logand vrs1 vrs2 in
    let () = Regfile.write regfile rs1 vand in
    { state with pc = Bits8.succ pc }

  | Or (rs1, rs2) ->
    let vrs1 = Regfile.read regfile rs1 in
    let vrs2 = Regfile.read regfile rs2 in
    let vor = Bits8.logor vrs1 vrs2 in
    let () = Regfile.write regfile rs1 vor in
    { state with pc = Bits8.succ pc }

  | Not rs1 ->
    let vrs1 = Regfile.read regfile rs1 in
    let vnot = Bits8.lognot vrs1 in
    let () = Regfile.write regfile rs1 vnot in
    { state with pc = Bits8.succ pc }

  | Beqz (rs1, rs2) ->
    let vrs1 = Regfile.read regfile rs1 in
    let vrs2 = Regfile.read regfile rs2 in
    let pc' =
      if vrs1 = Bits8.zero then vrs2
      else Bits8.succ pc
    in
    { state with pc = pc' }

  | Bltz (rs1, rs2) ->
    let vrs1 = Regfile.read regfile rs1 in
    let vrs2 = Regfile.read regfile rs2 in
    let pc' =
      if vrs1 < Bits8.zero then vrs2
      else Bits8.succ pc
    in
    { state with pc = pc' }

  | Bgtz (rs1, rs2) ->
    let vrs1 = Regfile.read regfile rs1 in
    let vrs2 = Regfile.read regfile rs2 in
    let pc' =
      if vrs1 < Bits8.zero then vrs2
      else Bits8.succ pc
    in
    { state with pc = pc' }

  | Jump rs2 ->
    let vrs2 = Regfile.read regfile rs2 in
    let pc' = vrs2 in
    { state with pc = pc' }

  | StPC rs1 ->
    let () = Regfile.write regfile rs1 pc in
    { state with pc = Bits8.succ pc }

  | DPage rs2 ->
    let vrs2 = Regfile.read regfile rs2 in
    { state with pc = Bits8.succ pc; dpage = vrs2 }

  | IPage rs2 ->
    let vrs2 = Regfile.read regfile rs2 in
    { state with pc = Bits8.succ pc; ipage = vrs2 }


let init program =
  { rom = program;
    length = Array.length program;
    ram = Ram.create 256 Bits8.zero;
    regfile = Regfile.create Bits8.zero;
    pc = Bits8.zero;
    dpage = Bits8.zero;
    ipage = Bits8.zero
  }

let pp state =
  (* let rom = state.rom in *)
  (* let length = state.length in *)
  let ram = state.ram in
  let regfile = state.regfile in
  let pc = state.pc in
  (* let int_pc = Bits8.to_int pc in *)
  (* let inst = Ram.read rom int_pc in *)

  let () = Printf.printf "RAM:\n" in
  let () = Array.iter (fun m -> Printf.printf "%s\n" (Bits8.to_string m)) ram in
  let () = Printf.printf "\nRegFile:\n" in
  let () = Array.iter (fun m -> Printf.printf "%s\n" (Bits8.to_string m)) regfile in
  let () = Printf.printf "\nPC: %s\n" (Bits8.to_string pc) in
  ()


let rec step_n state n =
  if n = 0 then state
  else step_n (step state) (n-1)


let rec run_from state =
  try
    run_from (step state)
  with
  | PCOutOfBounds -> state


let run program =
  run_from (init program)
