(* open Types
open Basics
open Common.Bits.Bit


type register_input = {inp: bit; load: bit}
type register_output = bit
type register_state = bit
let register
    (ip_st: register_input * register_state)
  : register_output * register_state
  =
  let ip = fst ip_st in
  let state = snd ip_st in
  let mux_out = mux2 {a= state; b=ip.inp; addr=ip.load} in
  (state, mux_out)


type register_x8_input = {inp: bit8; load: bit}
type register_x8_output = bit8
type register_x8_state = bit8
let register_x8
    (ip_st: register_x8_input * register_state)
  : register_x8_output * register_state
  =
  let ip = fst ip_st in
  let state = snd ip_st in
  let i7, i6, i5, i4, i3, i2, i1, i0 = ip.inp in *)
