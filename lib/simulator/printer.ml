open Cpu
open Butter_isa
open Common.Bits


let pp_rom state =
  let rom = state.rom in
  Array.map Base.to_string rom


let pp_rom_with_pc state =
  let rom = state.rom in
  let pc = state.pc in
  let pc_int = Bits8.to_int pc in
  Array.mapi
    (fun n inst ->
       Printf.sprintf "%s %s"
         (if n = pc_int then "*" else " ")
         (Base.to_string inst)
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
  Base.to_string inst


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
