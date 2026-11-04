(* La recherche est séparée de l'application, qui appartient à Machine.step. *)
let find
    (description : Types.description)
    ~(state : string)
    ~(read : char) : Types.transition option =
  let _ = (description, state, read) in
  failwith "TODO(transition): find"
