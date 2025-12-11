%{
  open Ast
%}

%token EOF

%token STEP
%token INST
%token PROG
%token REGISTER
%token MEM
%token DPAGE
%token IPAGE
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

  | INST;               { Show_instruction   }
  | PROG;               { Show_program       }
  | REGISTER;           { Show_regfile       }
  | REGISTER; reg=REG;  { Show_reg reg       }
  | MEM;                { Show_mem           }
  | MEM; addr=INT;      { Show_mem_addr addr }

  | DPAGE;              { Show_dpage         }
  | IPAGE;              { Show_ipage         }

  | HELP;  { Help }
  | QUIT;  { Quit }
