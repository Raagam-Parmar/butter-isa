open Types
open Basics
open Common.Bits

type half_adder_input = {a: bit; b: bit}
type half_adder_output = {sum: bit; cout: bit}
let half_adder ip =
  let sum = xor {a=ip.a; b=ip.b} in
  let carry = andd {a=ip.a; b=ip.b} in
  {sum=sum; cout=carry}


type full_adder_input = {a: bit; b: bit; cin: bit}
type full_adder_output = {sum: bit; cout: bit}
let full_adder ip =
  let ha_ab = half_adder {a=ip.a; b=ip.b} in
  let ha_abc = half_adder {a=ha_ab.sum; b=ip.cin} in
  let sum = ha_abc.sum in
  let cout = orr {a=ha_ab.cout; b=ha_abc.cout} in
  {sum=sum; cout=cout}


type adder_x8_input = {a: bit8; b: bit8}
type adder_x8_output = bit8
let adder_x8 (ip: adder_x8_input) : adder_x8_output =
  let a7, a6, a5, a4, a3, a2, a1, a0 = ip.a in
  let b7, b6, b5, b4, b3, b2, b1, b0 = ip.b in
  let sc0 = half_adder {a=a0; b=b0} in
  let sc1 = full_adder {a=a1; b=b1; cin=sc0.cout} in
  let sc2 = full_adder {a=a2; b=b2; cin=sc1.cout} in
  let sc3 = full_adder {a=a3; b=b3; cin=sc2.cout} in
  let sc4 = full_adder {a=a4; b=b4; cin=sc3.cout} in
  let sc5 = full_adder {a=a5; b=b5; cin=sc4.cout} in
  let sc6 = full_adder {a=a6; b=b6; cin=sc5.cout} in
  let sc7 = full_adder {a=a7; b=b7; cin=sc6.cout} in
  (
    sc7.sum,
    sc6.sum,
    sc5.sum,
    sc4.sum,
    sc3.sum,
    sc2.sum,
    sc1.sum,
    sc0.sum
  )


type incr_x8_input = bit8
type incr_x8_output = bit8
let incr_x8 ip =
  adder_x8 {
    a=ip;
    b=(
      Bit.O,
      Bit.O,
      Bit.O,
      Bit.O,
      Bit.O,
      Bit.O,
      Bit.O,
      Bit.I
    )
  }
