(* Cherche une transition (instruction) pour un état et un caractère. *)
let find
		(description : Types.description)
		(state : string)
		(read : char) : Types.transition option =
	(* cherche une clé dans une liste de couples. *)
	match List.assoc_opt state description.transitions with
	| None -> None
	| Some transitions ->
		List.find_opt
			(fun (transition : Types.transition) -> transition.read = read)
			transitions
