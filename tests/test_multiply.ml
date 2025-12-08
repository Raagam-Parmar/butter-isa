open Butter_isa.Simulate
open Butter_isa.Mnemonics

let multiply a b =
  [|
    (* Setup *)
    li_lo a;
    li_hi a;
    mov r1 r0;

    li_lo b;
    li_hi b;
    mov r2 r0;

    (* Calculation *)
    lli 0;
    mov r3 r0;

    (* LOOP *)
    li_lo 16;
    li_hi 16;
    beqz r1 r0;

    add r3 r2;

    lli 1;
    sub r1 r0;

    li_lo 8;
    li_hi 8;
    jump r0;

    (* HALT *)
    stpc r0;
    jump r0;
  |]

let init_state = init (multiply 15 17)
let final_state = step_n init_state 200
let () = pp final_state
