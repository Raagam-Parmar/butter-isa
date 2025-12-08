type 'a instruction =
  | Load  of Register.t * Register.t
  | Store of Register.t * Register.t

  | Lui   of 'a
  | Lli   of 'a

  | Move  of Register.t * Register.t
  | Add   of Register.t * Register.t
  | Sub   of Register.t * Register.t
  | And   of Register.t * Register.t
  | Or    of Register.t * Register.t
  | Not   of Register.t

  | Beqz  of Register.t * Register.t
  | Bltz  of Register.t * Register.t
  | Jump  of Register.t
  | StPC  of Register.t

  | DPage of Register.t
  | IPage of Register.t
