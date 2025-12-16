open Types
open Common.Bits

type nand_input = {a: bit; b: bit}
type nand_output = bit
let nand ip =
  match ip.a, ip.b with
  | O, O -> Bit.I
  | O, I -> Bit.I
  | I, O -> Bit.I
  | I, I -> Bit.O


type not_input = bit
type not_output = bit
let nott ip = nand {a=ip; b=ip}


type andd_input = {a: bit; b: bit}
type andd_output = bit
let andd ip =
  nott (nand {a=ip.a; b=ip.b})


type orr_input = {a: bit; b: bit}
type orr_output = bit
let orr ip =
  let not_a = nott ip.a in
  let not_b = nott ip.b in
  nand {a=not_a; b=not_b}


type xor_input = {a: bit; b: bit}
type xor_output = bit
let xor ip =
  orr {
    a=andd {a=ip.a; b=nott ip.b};
    b=andd {a=nott ip.a; b=ip.b}
  }


type mux2_input = {a: bit; b: bit; addr: bit}
type mux2_output = bit
let mux2 ip =
  let not_addr = nott ip.addr in
  orr {
    a=andd {a=ip.a; b=not_addr};
    b=andd {a=ip.b; b=ip.addr}
  }


type dmux2_input = {inp: bit; addr: bit}
type dmux2_output = bit * bit
let dmux2 ip =
  let out0 = andd {a=ip.inp; b=nott ip.addr} in
  let out1 = andd {a=ip.inp; b=ip.addr} in
  (out0, out1)


type not_x8_input = bit8
type not_x8_output = bit8
let not_x8 (ip: not_x8_input) : not_x8_output =
  let i7, i6, i5, i4, i3, i2, i1, i0 = ip in
  (
    nott i0,
    nott i1,
    nott i2,
    nott i3,
    nott i4,
    nott i5,
    nott i6,
    nott i7
  )


type andd_x8_input = {a: bit8; b: bit8}
type andd_x8_output = bit8
let andd_x8 (ip: andd_x8_input) : andd_x8_output =
  let a7, a6, a5, a4, a3, a2, a1, a0 = ip.a in
  let b7, b6, b5, b4, b3, b2, b1, b0 = ip.b in
  (
    andd {a=a7; b=b7},
    andd {a=a6; b=b6},
    andd {a=a5; b=b5},
    andd {a=a4; b=b4},
    andd {a=a3; b=b3},
    andd {a=a2; b=b2},
    andd {a=a1; b=b1},
    andd {a=a0; b=b0}
  )


type orr_x8_input = {a: bit8; b: bit8}
type orr_x8_output = bit8
let orr_x8 (ip: orr_x8_input) : orr_x8_output =
  let a7, a6, a5, a4, a3, a2, a1, a0 = ip.a in
  let b7, b6, b5, b4, b3, b2, b1, b0 = ip.b in
  (
    orr {a=a7; b=b7},
    orr {a=a6; b=b6},
    orr {a=a5; b=b5},
    orr {a=a4; b=b4},
    orr {a=a3; b=b3},
    orr {a=a2; b=b2},
    orr {a=a1; b=b1},
    orr {a=a0; b=b0}
  )


type xor_x8_input = {a: bit8; b: bit8}
type xor_x8_output = bit8
let xor_x8 (ip: xor_x8_input) : xor_x8_output =
  let a7, a6, a5, a4, a3, a2, a1, a0 = ip.a in
  let b7, b6, b5, b4, b3, b2, b1, b0 = ip.b in
  (
    xor {a=a7; b=b7},
    xor {a=a6; b=b6},
    xor {a=a5; b=b5},
    xor {a=a4; b=b4},
    xor {a=a3; b=b3},
    xor {a=a2; b=b2},
    xor {a=a1; b=b1},
    xor {a=a0; b=b0}
  )


type mux2_x8_input = {a: bit8; b: bit8; addr: bit}
type mux2_x8_output = bit8
let mux2_x8 (ip: mux2_x8_input) : mux2_x8_output =
  let a7, a6, a5, a4, a3, a2, a1, a0 = ip.a in
  let b7, b6, b5, b4, b3, b2, b1, b0 = ip.b in
  (
    mux2 {a=a7; b=b7; addr=ip.addr},
    mux2 {a=a6; b=b6; addr=ip.addr},
    mux2 {a=a5; b=b5; addr=ip.addr},
    mux2 {a=a4; b=b4; addr=ip.addr},
    mux2 {a=a3; b=b3; addr=ip.addr},
    mux2 {a=a2; b=b2; addr=ip.addr},
    mux2 {a=a1; b=b1; addr=ip.addr},
    mux2 {a=a0; b=b0; addr=ip.addr}
  )


type andd_3way_input = bit3
type andd_3way_output = bit
let andd_3way ip =
  let i2, i1, i0 = ip in
  let and01 = andd {a=i0; b=i1} in
  let and02 = andd {a=and01; b=i2} in
  and02


type orr_8way_input = bit8
type orr_8way_output = bit
let orr_8way (ip: orr_8way_input) : orr_8way_output =
  let i7, i6, i5, i4, i3, i2, i1, i0 = ip in
  let or01 = orr {a=i0; b=i1} in
  let or12 = orr {a=i2; b=or01} in
  let or23 = orr {a=i3; b=or12} in
  let or34 = orr {a=i4; b=or23} in
  let or45 = orr {a=i5; b=or34} in
  let or56 = orr {a=i6; b=or45} in
  let or67 = orr {a=i7; b=or56} in
  or67


type mux4_x8_input = {a: bit8; b: bit8; c: bit8; d: bit8; addr: bit2}
type mux4_x8_output = bit8
let mux4_x8 (ip: mux4_x8_input) : mux4_x8_output =
  let addr1, addr0 = ip.addr in
  let mux_ab = mux2_x8 {a=ip.a; b=ip.b; addr=addr0} in
  let mux_cd = mux2_x8 {a=ip.c; b=ip.d; addr=addr0} in
  let out = mux2_x8 {a=mux_ab; b=mux_cd; addr=addr1} in
  out


type fanout_1_8_input = bit
type fanout_1_8_output = bit8
let fanout_1_8 (ip: fanout_1_8_input) : fanout_1_8_output =
  (ip, ip, ip, ip, ip, ip, ip, ip)
