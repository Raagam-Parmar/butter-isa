open Butter_isa

type ('a, 'l) instruction =
  | Load  of Register.t * Register.t
  | Store of Register.t * Register.t

  | Lui   of 'a
  | Lli   of 'a
  | Li    of 'a (* pseudo-instruction *)
  | La    of 'l (* pseudo-instruction *)

  | Move  of Register.t * Register.t
  | Add   of Register.t * Register.t
  | Sub   of Register.t * Register.t
  | And   of Register.t * Register.t
  | Or    of Register.t * Register.t
  | Not   of Register.t

  | Beqz  of Register.t * Register.t
  | Bltz  of Register.t * Register.t
  | Bgez  of Register.t * Register.t (* pseudo-instruction *)
  | Bgtz  of Register.t * Register.t (* pseudo-instruction *)
  | Blez  of Register.t * Register.t (* pseudo-instruction *)
  | Bnez  of Register.t * Register.t (* pseudo-instruction *)

  | Jump  of Register.t
  | StPC  of Register.t

  | DPage of Register.t
  | IPage of Register.t

  | Label of 'l (* pseudo-instruction *)

type ('a, 'l) program = ('a, 'l) instruction list
