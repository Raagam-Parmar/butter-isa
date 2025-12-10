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
reg rx   - Show contents of register `rx`
mem addr - Show contents of memory address `addr`
help     - Show help text
quit     - Quit repl"


let show_help () = print_endline help_text

let exec state command =
  match command with
  | Step n -> Cpu.step_n state n

  | Show_instruction ->
    begin
      Printf.printf "%s\n" (Cpu.pp_instruction state);
      state
    end

  | Show_reg r ->
    begin
      Printf.printf "%s\n" (Cpu.pp_register state r);
      state
    end

  | Show_mem addr ->
    let () =
      if not (in_range 0 256 addr)
      then
        Printf.printf
          "Error: Address %d out of range.\n"
          addr
      else
        Printf.printf "%s\n" (Cpu.pp_ram_addr state addr)
    in
    state

  | Help -> show_help (); state
  | Quit -> raise QuitREPL


let repl initial_state =
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
  loop initial_state
