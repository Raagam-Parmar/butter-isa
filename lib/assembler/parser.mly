%{
  open Butter_isa.Isa
%}

%token EOF

%token LOAD
%token STORE

%token LUI
%token LLI

%token MOV
%token ADD
%token SUB
%token AND
%token OR
%token NOT

%token BEQZ
%token BLTZ
%token JUMP
%token STPC

%token DPAGE
%token IPAGE

%token <Butter_isa.Register.t> REG
%token <Common.Modulo.Mod16.t> IMM

%token COLON
%token <string> LABEL

%start <(Common.Modulo.Mod16.t, string) Ast.program> main

%%

let main :=
  | blk=block*; EOF;          { blk }

let block :=
  | label=LABEL; COLON; body=instruction*;
    { Ast.{label=label; body=body} }

let instruction :=
  | LOAD ; rs1=REG; rs2=REG;  { Load  (rs1, rs2) }
  | STORE; rs1=REG; rs2=REG;  { Store (rs1, rs2) }

  | LUI  ;          imm=IMM;  { Lui         imm  }
  | LLI  ;          imm=IMM;  { Lli         imm  }

  | MOV  ; rs1=REG; rs2=REG;  { Move  (rs1, rs2) }
  | ADD  ; rs1=REG; rs2=REG;  { Add   (rs1, rs2) }
  | SUB  ; rs1=REG; rs2=REG;  { Sub   (rs1, rs2) }
  | AND  ; rs1=REG; rs2=REG;  { And   (rs1, rs2) }
  | OR   ; rs1=REG; rs2=REG;  { Or    (rs1, rs2) }
  | NOT  ; rs1=REG         ;  { Not    rs1       }

  | BEQZ ; rs1=REG; rs2=REG;  { Beqz  (rs1, rs2) }
  | BLTZ ; rs1=REG; rs2=REG;  { Bltz  (rs1, rs2) }
  | JUMP ;          rs2=REG;  { Jump        rs2  }
  | STPC ; rs1=REG         ;  { StPC   rs1       }

  | DPAGE;          rs2=REG;  { DPage       rs2  }
  | IPAGE;          rs2=REG;  { IPage       rs2  }
