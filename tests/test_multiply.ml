open Butter_sim.Simulate
open Butter_as.Assembler

let rec to_array = function
  | [] -> [||]
  | x :: xs -> Array.append [|x|] (to_array xs)

let multiply =
  "
  # multiply two numbers a and b
  # where a is in r1
  # and   b is in r2
  # result is stored in r3

  # setup
      li   15     # r1 = a
      mov  r1 r0

      li   17
      mov  r2 r0 # r2 = b

  # calcuation

  # setup accumulator
      li   0     # r3 = 0
      mov  r3 r0

  LOOP:
      la   HALT  # if a = 0 then halt
      beqz r1 r0

      add  r3 r2 # acc += b

      lli  1     # r1 -= 1
      sub  r1 r0

      la   LOOP
      jump r0

  HALT:
      stpc r0
      jump r0
  "


let assembled = to_array (assemble (parse multiply))
let init_state = init assembled
let final_state = step_n init_state 200
let () = pp final_state
