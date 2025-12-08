(lang dune 3.20)
(using menhir 3.0)

(name butter-isa)

(generate_opam_files false)

(source
 (github Raagam-Parmar/butter-isa))

(authors "Raagam Parmar <raagamparmar@gmail.com>")

(maintainers "Raagam Parmar <raagamparmar@gmail.com>")

(license LICENSE)

(documentation https://url/to/documentation)

(package
 (name butter-isa)
 (synopsis "An 8-bit ISA for a breadboard computer")
 (description "A longer description")
 (depends ocaml)
 (tags
  ("add topics" "to describe" your project)))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/reference/dune-project/index.html
