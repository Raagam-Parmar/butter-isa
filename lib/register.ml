type t =
  | R0
  | R1
  | R2
  | R3

let to_int = function
  | R0 -> 0
  | R1 -> 1
  | R2 -> 2
  | R3 -> 3
