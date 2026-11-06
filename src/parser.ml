(* Représente une erreur contrôlée dans la description de la machine. *)
exception Validation_error of string

(* Interrompt le parsing avec un message destiné à l'utilisateur. *)
let fail_validation message =
  raise (Validation_error message)

(* Extrait un champ obligatoire d'un objet JSON. *)
let required name fields =
  match List.assoc_opt name fields with
  | Some value -> value
  | None -> fail_validation (name ^ " is missing")

(* Convertit une valeur JSON en objet. *)
let as_object context = function
  | `Assoc fields -> fields
  | _ -> fail_validation (context ^ " must be an object")

(* Convertit une valeur JSON en liste. *)
let as_list context = function
  | `List values -> values
  | _ -> fail_validation (context ^ " must be a list")

(* Convertit une valeur JSON en chaîne. *)
let as_string context = function
  | `String value -> value
  | _ -> fail_validation (context ^ " must be a string")

(* Convertit une chaîne JSON de longueur un en caractère. *)
let as_char context json =
  let value = as_string context json in
  if String.length value = 1 then value.[0]
  else fail_validation (context ^ " must have length 1")

(* Cherche la première valeur présente plusieurs fois. *)
let find_duplicate values =
  let rec find seen = function
    | [] -> None
    | value :: rest ->
        if List.mem value seen then Some value
        else find (value :: seen) rest
  in
  find [] values

(* Refuse une liste qui contient un doublon. *)
let ensure_unique context values =
  match find_duplicate values with
  | None -> ()
  | Some _ -> fail_validation (context ^ " contains a duplicate")

(* Parse un champ contenant une liste de chaînes. *)
let parse_string_list name fields =
  required name fields
  |> as_list name
  |> List.map (as_string (name ^ " item"))

(* Parse l'alphabet sous forme de caractères. *)
let parse_alphabet fields =
  required "alphabet" fields
  |> as_list "alphabet"
  |> List.map (as_char "alphabet item")

(* Parse une règle de transition. *)
let parse_transition state json =
  let context = "transition for " ^ state in
  let fields = as_object context json in
  let read = required "read" fields |> as_char (context ^ " read") in
  let write = required "write" fields |> as_char (context ^ " write") in
  let next_state =
    required "to_state" fields |> as_string (context ^ " to_state")
  in
  let action =
    match required "action" fields |> as_string (context ^ " action") with
    | "LEFT" -> Types.Left
    | "RIGHT" -> Types.Right
    | _ -> fail_validation (context ^ " action must be LEFT or RIGHT")
  in
  { Types.read = read; write; next_state; action }

(* Parse les listes de transitions indexées par état. *)
let parse_transitions fields =
  fields
  |> List.map
       (fun (state, json_transitions) ->
         let transitions =
           json_transitions
           |> as_list ("transitions for " ^ state)
           |> List.map (parse_transition state)
         in
         (state, transitions))

(* Vérifie les références et symboles d'une transition. *)
let validate_transition alphabet states state (transition : Types.transition) =
  if not (List.mem transition.next_state states) then
    fail_validation ("to_state " ^ transition.next_state ^ " is not in states");
  if not (List.mem transition.read alphabet) then
    fail_validation ("read symbol is not in alphabet for " ^ state);
  if not (List.mem transition.write alphabet) then
    fail_validation ("write symbol is not in alphabet for " ^ state)

(* Vérifie les transitions associées à un état. *)
let validate_state_transitions alphabet states (state, transitions) =
  if not (List.mem state states) then
    fail_validation ("transition state " ^ state ^ " is not in states");
  List.iter (validate_transition alphabet states state) transitions;
  let reads =
    List.map (fun (transition : Types.transition) -> transition.read) transitions
  in
  match find_duplicate reads with
  | None -> ()
  | Some symbol ->
      fail_validation
        (Printf.sprintf "duplicate transition for (%s, %c)" state symbol)

(* Vérifie la cohérence globale d'une description. *)
let validate_description (description : Types.description) =
  ensure_unique "alphabet" description.alphabet;
  ensure_unique "states" description.states;
  ensure_unique "finals" description.finals;
  ensure_unique "transition keys" (List.map fst description.transitions);
  if not (List.mem description.blank description.alphabet) then
    fail_validation "blank is not in alphabet";
  if not (List.mem description.initial description.states) then
    fail_validation "initial is not in states";
  List.iter
    (fun final ->
      if not (List.mem final description.states) then
        fail_validation "a final is not in states")
    description.finals;
  List.iter
    (validate_state_transitions description.alphabet description.states)
    description.transitions

(* Parse tous les champs d'une description de machine. *)
let parse_description json =
  let fields = as_object "machine" json in
  let name = required "name" fields |> as_string "name" in
  let alphabet = parse_alphabet fields in
  let blank = required "blank" fields |> as_char "blank" in
  let states = parse_string_list "states" fields in
  let initial = required "initial" fields |> as_string "initial" in
  let finals = parse_string_list "finals" fields in
  let transitions =
    required "transitions" fields
    |> as_object "transitions"
    |> parse_transitions
  in
  { Types.name = name;
    alphabet;
    blank;
    states;
    initial;
    finals;
    transitions }

(* Charge, parse et valide une description sans laisser fuir d'exception utilisateur. *)
let load_machine (path : string) : (Types.description, string) result =
  try
    let description = Yojson.Safe.from_file path |> parse_description in
    validate_description description;
    Ok description
  with
  | Validation_error message -> Error message
  | Sys_error message -> Error ("file error: " ^ message)
  | Yojson.Json_error message -> Error ("invalid JSON: " ^ message)
  | Yojson.Safe.Util.Type_error (message, _) -> Error ("invalid JSON: " ^ message)

let validate_input
    (description : Types.description)
    (input : string) : (unit, string) result =
  let _ = (description, input) in
  Error "TODO(parser): validate the input alphabet"
