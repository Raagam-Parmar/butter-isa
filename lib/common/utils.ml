(** [in_range lo hi n] checks if [ n ] is in the (inclusive) interval [ [ lo, hi ] ]. *)
let in_range lo hi n =
  (lo <= n) && (n <= hi)

let rec list_to_array = function
  | [] -> [||]
  | x :: xs -> Array.append [|x|] (list_to_array xs)
