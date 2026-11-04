type configuration = {
  description : Types.description;
  tape : Tape.t;
  state : string;
}

type step_result =
  | Continue of configuration * Types.transition
  | Halted of configuration
  | Blocked of configuration * string

let initialize (description : Types.description) (input : string) : configuration =
  let _ = (description, input) in
  failwith "TODO(machine): initialize"

let step (configuration : configuration) : step_result =
  let _ = configuration in
  failwith "TODO(machine): step"

let run (configuration : configuration) : step_result =
  let _ = configuration in
  failwith "TODO(machine): run"
