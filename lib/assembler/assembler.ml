let parse s =
    let lexbuf = Lexing.from_string s in
    let ast = Parser.main Lexer.read lexbuf in
    ast
