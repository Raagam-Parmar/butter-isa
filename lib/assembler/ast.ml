open Butter_isa

type 'a instruction = 'a Isa.instruction

type ('a, 'l) block =
  { label: 'l;
    body: 'a instruction list
  }

type ('a, 'l) program = ('a, 'l) block list
