open Butter_sim.Simulate
open Butter_isa.Mnemonics

let random_a =
  [|
    lli 3;
    lui 10;
    add r2 r0;
    store r0 r1;
    load r1 r1;
    stpc r3;
    jump r3
  |]


let init_state = init random_a
let final_state = step_n init_state 200
let () = pp final_state
