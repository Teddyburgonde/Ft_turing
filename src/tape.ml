(* Un ruban centré sur la tête de lecture *)
type t = {
  left : char list;
  current : char;
  right : char list;
  blank : char;
}

(* Créer un ruban à partir de l'entrée *)
let create (blank : char) (input : string) : t =
	match List.of_seq (String.to_seq input) with
	| [] -> { left = []; current = blank; right = []; blank }
	| current :: right -> { left = []; current; right; blank }

(* Lit le caractère à la position de la tête. *)
let read (tape : t) : char =
	tape.current

(* Copie le ruban en remplaçant le caractère courant. *)
let write (symbol : char) (tape : t) : t =
	{ tape with current = symbol }


let move (direction : Types.direction) (tape : t) : t =
  let _ = (direction, tape) in
  failwith "TODO(tape): move"

let to_string (tape : t) : string =
  let _ = tape in
  failwith "TODO(tape): to_string"

