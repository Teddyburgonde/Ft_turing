(* Récupère les arguments du terminal *)
let parse_arguments ... 
(* jsonfile et input 
Sys.argv.(0) (Nom du programme)
Sys.argv.(1) (Fichier JSON)
Sys.argv.(2) (Input)
*)

(* Affiche l'aide avec --help *)
let display_help ...


let () = 
(* Récupère et vérifie les arguments du terminal *)
let parse_arguments ...

(* Charge le fichier JSON *)
Parser.load ...

(* Vérifie la validité des données JSON *)
Parser.validate ...

(* Convertit les données JSON en structures OCaml *)
Parser.convert_to_machine ...

(* Initialise la machine de Turing *)
Machine.initialize ...

(* Exécute la machine jusqu'à l'arrêt *)
Machine.run ...

