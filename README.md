# ft_turing

Simulateur fonctionnel de machine de Turing à une tête et un ruban infini,
écrit en OCaml. Il charge une description JSON, valide l'entrée, puis exécute
la machine transition par transition.


## Architecture

- `src/types.ml` : types partagés (`direction`, `transition`, `description`).
- `src/colors.ml` : codes ANSI utilisés pour mettre la tête en évidence.
- `src/tape.ml` : zipper immuable représentant ensemble le ruban et la tête.
- `src/transition.ml` : recherche d'une transition.
- `src/parser.ml` : lecture/validation de la description et de l'entrée.
- `src/machine.ml` : configuration, exécution d'un pas et boucle d'exécution.
- `src/main.ml` : CLI, affichage de la description et trace de l'exécution.

## Machines

Quatre descriptions JSON sont disponibles :

- `machines/unary_add.json` : addition unaire, par exemple `111+11` ;
- `machines/palindrome.json` : reconnaissance d'un palindrome binaire ;
- `machines/0n1n.json` : reconnaissance du langage `0^n1^n` ;
- `machines/02n.json` : reconnaissance d'un nombre pair de `0`.

## Compilation

Prérequis : OPAM initialisé et un switch actif contenant `ocamlc` et
`ocamlopt`. Le Makefile ne crée pas de switch. Il installe `ocamlfind` et
`yojson` dans le switch actif s'ils manquent.

```sh
make deps     # vérifie les outils et installe les dépendances
make          # construit l'exécutable natif ft_turing
make byte     # construit le bytecode ft_turing.byte
make test     # construit les deux versions et vérifie --help
make clean    # supprime les fichiers intermédiaires
make fclean   # supprime aussi les exécutables
make re       # reconstruit l'exécutable natif
```

## Utilisation

```sh
./ft_turing --help
./ft_turing machines/unary_add.json "111+11"
./ft_turing machines/palindrome.json "0110"
./ft_turing machines/0n1n.json "000111"
./ft_turing machines/02n.json "0000"
```

Le programme affiche d'abord la description complète de la machine, puis le
ruban et la transition exécutée à chaque étape. Le caractère sous la tête est
affiché en cyan et en gras. Une entrée contenant le caractère blanc ou un
symbole absent de l'alphabet est rejetée.
