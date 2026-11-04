(* Le ruban et la tête forment un zipper immuable. *)
type t = {
  left : char list;
  current : char;
  right : char list;
  blank : char;
}

let create ~(blank : char) (input : string) : t =
  let _ = (blank, input) in
  failwith "TODO(tape): create"

let read (tape : t) : char =
  let _ = tape in
  failwith "TODO(tape): read"

let write (symbol : char) (tape : t) : t =
  let _ = (symbol, tape) in
  failwith "TODO(tape): write"

let move (direction : Types.direction) (tape : t) : t =
  let _ = (direction, tape) in
  failwith "TODO(tape): move"

let to_string (tape : t) : string =
  let _ = tape in
  failwith "TODO(tape): to_string"

