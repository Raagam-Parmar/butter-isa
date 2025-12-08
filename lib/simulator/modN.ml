module type ModSig =
sig
  val modulus : int
end

module Make (M: ModSig) : sig
  type t
  val create : int -> t
  val zero : t
  val to_int : t -> int
  val add : t -> t -> t
  val sub : t -> t -> t
  val succ : t -> t
  val pred : t -> t
  val logand : t -> t -> t
  val logor : t -> t -> t
  val lognot : t -> t
  val shift_left : t -> t -> t
  val compare : t -> t -> int
  val to_string : t -> string
end = struct
  let pmod a n =
    let r = a mod n in
    if r < 0 then r + n else r

  type t = int
  let modulus = M.modulus
  let create n = pmod n modulus
  let zero = create 0
  let to_int m = m
  let add a b = pmod (a + b) modulus
  let sub a b = pmod (a - b) modulus
  let succ a = pmod (a + 1) modulus
  let pred a = pmod (a - 1) modulus
  let logand = Int.logand
  let logor = Int.logor
  let lognot = Int.lognot
  let shift_left = Int.shift_left
  let compare = Int.compare
  let to_string = Int.to_string
end
