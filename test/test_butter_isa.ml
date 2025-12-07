open Butter_isa.Isa
open Butter_isa.Simulate

let prog_a =
  [|
    Lli (Mod16.create 3);
    Lui (Mod16.create 10);
    Add (R2, R0);
    Store (R0, R1);
    Load (R1, R1);
    StPC R3
  |]

let () = pp (run prog_a)
