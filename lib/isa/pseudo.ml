open Base
open Common.Bits

type instruction =
  | Li of Bits8.t

  | Bgez  of Register.t * Register.t
  | Blez  of Register.t * Register.t
  | Bnez  of Register.t * Register.t


let to_base instruction =
  match instruction with
  | Li b ->
    let b_lo = bits8_to_bits4 b in
    let b_hi =
      bits8_to_bits4
        (Bits8.shift_right
           (Bits8.from_int 4) b)
    in
    if b_hi = Bits4.zero
    then [ Lli b_lo ]
    else [ Lli b_lo; Lui b_hi ]

  | Bgez (rs1, rs2) ->
    [ Bgtz (rs1, rs2); Beqz (rs1, rs2) ]

  | Blez (rs1, rs2) ->
    [ Bltz (rs1, rs2); Beqz (rs1, rs2) ]

  | Bnez (rs1, rs2) ->
    [ Bltz (rs1, rs2); Bgtz (rs1, rs2) ]
