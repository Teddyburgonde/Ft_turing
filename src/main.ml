(* Affiche l'aide de la ligne de commande. *)
let display_help () =
	print_endline "usage: ft_turing [-h] jsonfile input";
	print_endline "";
	print_endline "positional arguments:";
	print_endline "  jsonfile    json description of the machine";
	print_endline "  input       input of the machine";
	print_endline "";
	print_endline "optional arguments:";
	print_endline "  -h, --help  show this help message and exit"


(* Convertit une direction en texte pour l'affichage. *)
let direction_to_string (direction : Types.direction) : string =
	match direction with
	| Types.Left -> "LEFT"
	| Types.Right -> "RIGHT"


(* Formate une liste de textes entre crochets. *)
let format_list (values : string list) : string =
	"[ " ^ String.concat ", " values ^ " ]"


(* Formate une transition selon la notation du sujet. *)
let format_transition
		(state : string)
		(transition : Types.transition) : string =
	Printf.sprintf
		"(%s, %c) -> (%s, %c, %s)"
		state
		transition.read
		transition.next_state
		transition.write
		(direction_to_string transition.action)

(* Affiche la description complète de la machine. *)
let display_description (description : Types.description) : unit =
	let separator = String.make 80 '*' in
	let alphabet =
		description.alphabet
		|> List.map (String.make 1)
		|> format_list
	in
	print_endline separator;
	Printf.printf "Machine: %s\n" description.name;
	Printf.printf "Alphabet: %s\n" alphabet;
	Printf.printf "Blank: %c\n" description.blank;
	Printf.printf "States: %s\n" (format_list description.states);
	Printf.printf "Initial: %s\n" description.initial;
	Printf.printf "Finals: %s\n" (format_list description.finals);
	print_endline "Transitions:";
	List.iter
		(fun (state, transitions) ->
			List.iter
				(fun transition -> print_endline (format_transition state transition))
				transitions)
		description.transitions;
	print_endline separator


(* Affiche le ruban avant la transition qui va être exécutée. *)
let display_step
		(configuration : Machine.configuration)
		(transition : Types.transition) : unit =
	Printf.printf
		"%s %s\n"
		(Tape.to_string configuration.tape)
		(format_transition configuration.state transition)


(* Affiche une erreur et renvoie le code d'échec. *)
let report_error message =
	prerr_endline ("ft_turing: " ^ message);
	1


(* Exécute la machine pas à pas en affichant toute sa trace. *)
let rec run_with_trace (configuration : Machine.configuration) : int =
	match Machine.step configuration with
	| Machine.Continue (next_configuration, transition) ->
		display_step configuration transition;
		run_with_trace next_configuration
	| Machine.Halted final_configuration ->
		Printf.printf
			"%s Halted in state %s\n"
			(Tape.to_string final_configuration.tape)
			final_configuration.state;
		0
	| Machine.Blocked (blocked_configuration, reason) ->
		flush stdout;
		Printf.eprintf "%s\n" (Tape.to_string blocked_configuration.tape);
		report_error reason


(* Charge, valide, affiche puis exécute une machine. *)
let run_machine jsonfile input =
	match Parser.load_machine jsonfile with
	| Error message -> report_error message
	| Ok description ->
			(match Parser.validate_input description input with
			 | Error message -> report_error message
			 | Ok () ->
					 display_description description;
					 Machine.initialize description input |> run_with_trace)


(* Analyse les arguments et choisit l'action à effectuer. *)
let main () =
	match Array.to_list Sys.argv with
	| [_; ("-h" | "--help")] ->
			display_help ();
			0
	| [_; jsonfile; input] -> run_machine jsonfile input
	| _ ->
			display_help ();
			1

(* Lance le programme avec le code de sortie calculé par main. *)
let () = exit (main ())