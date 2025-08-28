open Source

exception ParseError of region * string
exception UnparseError of string
exception ElabError of region * string
exception InterpError of region * string

let debug_errors = false

let string_of_error at msg =
  if at = no_region then msg else string_of_region at ^ ": " ^ msg

let warn (at : region) (category : string) (msg : string) =
  Printf.eprintf "%s\n%!" (string_of_error at (category ^ " warning: " ^ msg))

(* Parser errors *)

let error_parse (at : region) (msg : string) = raise (ParseError (at, msg))

(* Unparser errors *)

let error_unparse (msg : string) = raise (UnparseError msg)

(* Elaboration errors *)

let error_elab (at : region) (msg : string) = raise (ElabError (at, msg))
let warn_elab (at : region) (msg : string) = warn at "elab" msg

(* Interpreter errors *)

let error_interp (at : region) (msg : string) = raise (InterpError (at, msg))
let warn_interp (at : region) (msg : string) = warn at "interp" msg
