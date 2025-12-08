type 'a t = 'a Array.t

let create = Array.make

let read ram addr = ram.(addr)

let write ram addr data = ram.(addr) <- data
