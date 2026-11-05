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
  match direction with
  | Types.Right ->
      (match tape.right with
       | next :: rest ->
           { tape with
             left = tape.current :: tape.left;
             current = next;
             right = rest }
       | [] ->
           { tape with
             left = tape.current :: tape.left;
             current = tape.blank })
  | Types.Left ->
      (match tape.left with
       | previous :: rest ->
           { tape with
             left = rest;
             current = previous;
             right = tape.current :: tape.right }
       | [] ->
           { tape with
             current = tape.blank;
             right = tape.current :: tape.right })

let to_string (tape : t) : string =
  let left = String.of_seq (List.to_seq (List.rev tape.left)) in
  let right = String.of_seq (List.to_seq tape.right) in
  Printf.sprintf "[%s<%c>%s]" left tape.current right

