open Ast
open Parser
open Butter_sim
open Common.Utils

exception QuitREPL

let parse s =
  try
    let lexbuf = Lexing.from_string s in
    let cmd = Parser.main Lexer.read lexbuf in
    Some cmd
  with
  | Error | Failure _ -> None


let help_text =
  "step     - Step through one cycle
step n   - Step through `n` cycles
inst     - Show current instruction
prog     - Show current program
reg      - Show register file
reg rx   - Show contents of register `rx`
mem      - Show contents of memory
mem addr - Show contents of memory address `addr`
dpage    - Show RAM page register
ipage    - Show ROM page register
help     - Show help text
quit     - Quit repl"


let show_help () = print_endline help_text

let exec state command =
  match command with
  | Step n ->
    begin
      match Cpu.step_n state n with
      | (state', None) -> state'
      | (state', Some e) ->
        Cpu.report_step_error e;
        state'
    end

  | Show_instruction ->
    Printf.printf "%s\n" (Printer.pp_instruction state);
    state

  | Show_program ->
    Array.iter
      print_endline
      (Printer.pp_rom_with_pc state);
    state

  | Show_regfile ->
    Array.iter print_endline (Printer.pp_regfile state);
    state

  | Show_reg r ->
    Printf.printf "%s\n" (Printer.pp_register state r);
    state

  | Show_mem ->
    Array.iter print_endline (Printer.pp_ram state);
    state

  | Show_mem_addr addr ->
    let () =
      if not (in_range 0 256 addr)
      then
        Printf.printf
          "Error: Address %d out of range.\n"
          addr
      else
        Printf.printf "%s\n" (Printer.pp_ram_addr state addr)
    in
    state

  | Show_dpage ->
    print_endline (Printer.pp_dpage state);
    state

  | Show_ipage ->
    print_endline (Printer.pp_ipage state);
    state

  | Help -> show_help (); state
  | Quit -> raise QuitREPL


let repl init =
  let rec loop state =
    print_string "> ";
    flush stdout;

    let input = read_line () in
    match parse input with
    | None ->
      print_endline "Unknown command";
      loop state
    | Some cmd ->
      try
        let state' = exec state cmd in
        loop state'
      with QuitREPL ->
        print_endline "Exiting"
  in
  loop init
