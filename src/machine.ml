(* Regroupe la description, le ruban et l'état courant de la machine. *)
type configuration = {
	description : Types.description;
	tape : Tape.t;
	state : string;
}


(* Décrit le résultat d'une étape d'exécution. *)
type step_result =
	| Continue of configuration * Types.transition
	| Halted of configuration
	| Blocked of configuration * string


(* Crée la configuration initiale à partir de la description et de l'entrée. *)
let initialize (description : Types.description) (input : string) : configuration =
	{ description;
		tape = Tape.create description.blank input;
		state = description.initial }


(* Exécute une seule étape de la machine. *)
let step (configuration : configuration) : step_result =
	(* Vérifie si la machine est déjà dans un état final. *)
	if List.mem configuration.state configuration.description.finals then
		Halted configuration
	else
		(* Lit le caractère situé sous la tête de lecture. *)
		let symbol = Tape.read configuration.tape in
		(* Cherche l'instruction correspondant à l'état et au caractère lus. *)
		match Transition.find configuration.description configuration.state symbol with
		| None ->
			(* Aucune instruction trouvée : la machine est bloquée. *)
			Blocked
				(configuration,
				 Printf.sprintf
					 "machine is blocked in state %s on symbol %c"
					 configuration.state
					 symbol)
		| Some transition ->
			(* Crée un ruban en écrivant puis en déplaçant la tête. *)
			let tape =
				configuration.tape
				|> Tape.write transition.write
				|> Tape.move transition.action
			in
			(* Crée une nouvelle configuration contenant le nouveau ruban et le nouvel état. *)
			let next_configuration =
				{ configuration with tape; state = transition.next_state }
			in
			(* Renvoie la configuration avec le nouveau ruban et l'instruction exécutée. *)
			Continue (next_configuration, transition)


(* Enchaîne les étapes jusqu'à un arrêt final ou un blocage. *)
let rec run (configuration : configuration) : step_result =
	match step configuration with
	| Continue (next_configuration, _) -> run next_configuration
	| Halted _ as result -> result
	| Blocked _ as result -> result
