%{
  open Ast
%}

%token EOF

%token STEP
%token INST
%token REGISTER
%token MEM
%token HELP
%token QUIT

%token <Butter_isa.Register.t> REG
%token <int> INT

%start <Ast.command> main

%%

let main :=
  | cmd=command; EOF; { cmd }

let command :=
  | STEP;         { Step 1 }
  | STEP; n=INT;  { Step n }

  | INST;               { Show_instruction }
  | REGISTER; reg=REG;  { Show_reg reg     }
  | MEM; addr=INT;      { Show_mem addr    }

  | HELP;  { Help }
  | QUIT;  { Quit }
