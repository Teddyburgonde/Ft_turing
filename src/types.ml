(* Déplacement de la tête de lecture. *)
type direction = Left | Right

(* Action à effectuer selon le caractère lu. *)
type transition = {
	read : char;
	write : char;
	next_state : string;
	action : direction;
}

(* Description complète de la machine. *)
type description = {
	name : string;
	alphabet : char list;
	blank : char;
	states : string list;
	initial : string;
	finals : string list;
	(* Liste associant chaque état à ses transitions. *)
	transitions : (string * transition list) list;
}
