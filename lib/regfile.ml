type 'a t = 'a Array.t

let create x = Array.make 4 x

let read regfile reg =
  let addr = Register.to_int reg in
  regfile.(addr)

let write regfile reg data =
  let addr = Register.to_int reg in
  regfile.(addr) <- data
