(* Les erreurs utilisateur sont renvoyées explicitement à Main. *)
let load_machine (path : string) : (Types.description, string) result =
  let _ = path in
  Error "TODO(parser): load and validate the JSON machine description"

let validate_input
    (description : Types.description)
    (input : string) : (unit, string) result =
  let _ = (description, input) in
  Error "TODO(parser): validate the input alphabet"
