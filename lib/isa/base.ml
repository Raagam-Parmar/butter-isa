open Common.Bits

type instruction =
  | Load  of Register.t * Register.t
  | Store of Register.t * Register.t

  | Lui   of Bits4.t
  | Lli   of Bits4.t

  | Move  of Register.t * Register.t
  | Add   of Register.t * Register.t
  | Sub   of Register.t * Register.t
  | And   of Register.t * Register.t
  | Or    of Register.t * Register.t
  | Not   of Register.t

  | Beqz  of Register.t * Register.t
  | Bltz  of Register.t * Register.t
  | Bgtz  of Register.t * Register.t

  | Jump  of Register.t
  | StPC  of Register.t

  | DPage of Register.t
  | IPage of Register.t
