open Butter_isa
open Common.Bits

exception PCOutOfBounds


type 'a state =
  { rom: Base.instruction Ram.t;
    length: int;
    ram: 'a Ram.t;
    regfile: 'a Regfile.t;
    pc: 'a;
    dpage: 'a;
    ipage: 'a
  }


(** Initial program state *)
let init program =
  { rom = program;
    length = Array.length program;
    ram = Ram.create 256 Bits8.zero;
    regfile = Regfile.create Bits8.zero;
    pc = Bits8.zero;
    dpage = Bits8.zero;
    ipage = Bits8.zero
  }


(** Step through one cycle.
    Raise [PCOutOfBounds] if pc is out of program bounds. *)
let step state =
  let rom = state.rom in
  let length = state.length in
  let ram = state.ram in
  let regfile = state.regfile in
  let pc = state.pc in
  let int_pc = Bits8.to_int pc in

  let () =
    if int_pc >= length
    then raise PCOutOfBounds
    else ()
  in

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


(** Step through [n] cycles.
    Raise [PCOutOfBounds] if pc is out of program bounds. *)
let rec step_n state n =
  if n = 0 then state
  else step_n (step state) (n-1)


let pp_rom state =
  let rom = state.rom in
  Array.map Pretty.pp rom


let pp_rom_with_pc state =
  let rom = state.rom in
  let pc = state.pc in
  let pc_int = Bits8.to_int pc in
  Array.mapi
    (fun n inst ->
       Printf.sprintf "%s %s"
         (if n = pc_int then "*" else " ")
         (Pretty.pp inst)
    )
    rom


let pp_length state =
  Int.to_string state.length


let pp_ram state =
  let ram = state.ram in
  Array.mapi
    (fun i b ->
       Printf.sprintf "%d\t%s"
         i
         (Bits8.to_string b)
    ) ram


let pp_ram_addr state addr =
  Bits8.to_string (state.ram.(addr))


let pp_regfile state =
  let regfile = state.regfile in
  Array.mapi
    (fun i b ->
       Printf.sprintf "r%d\t%s"
         i
         (Bits8.to_string b)
    )
    regfile


let pp_register state reg =
  let reg_int = Register.to_int reg in
  Bits8.to_string (state.regfile.(reg_int))


let pp_pc state =
  Bits8.to_string state.pc


let pp_dpage state =
  Bits8.to_string state.dpage


let pp_ipage state =
  Bits8.to_string state.ipage


let pp_instruction state =
  let pc_int = Bits8.to_int state.pc in
  let inst = state.rom.(pc_int) in
  Pretty.pp inst


let print_str_array arr =
  Array.iter print_endline arr


let pp_state state =
  begin
    print_endline "\nROM:";
    print_str_array (pp_rom_with_pc state);

    print_endline "\nRAM:";
    print_str_array (pp_ram state);

    print_endline "\nRegister File:";
    print_str_array (pp_regfile state);

    print_endline "\nPC:";
    print_endline (pp_pc state);

    print_endline "\nDpage:";
    print_endline (pp_dpage state);

    print_endline "\nIpage:";
    print_endline (pp_ipage state)
  end
