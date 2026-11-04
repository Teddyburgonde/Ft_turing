# ft_turing

Squelette pédagogique d'un simulateur fonctionnel de machine de Turing à une
tête et un ruban infini, écrit en OCaml.


## Architecture

- `src/types.ml` : types partagés (`direction`, `transition`, `description`).
- `src/tape.ml` : zipper immuable représentant ensemble le ruban et la tête.
- `src/transition.ml` : recherche d'une transition.
- `src/parser.ml` : lecture/validation de la description et de l'entrée.
- `src/machine.ml` : configuration, exécution d'un pas et boucle d'exécution.
- `src/main.ml` : arguments et affichage des erreurs.

## Compilation

```sh
make          # exécutable natif ft_turing
make byte     # bytecode ft_turing.byte
make test     # compile les deux versions et vérifie leurs aides
make deps     # vérifie/installe ocamlfind et yojson via OPAM
```

Le Makefile exige OPAM et un switch actif contenant `ocamlc` et `ocamlopt`.
Il ne crée pas de switch et ne modifie pas automatiquement l'environnement
global. Dans le switch actif, il installe seulement `ocamlfind` et `yojson`
s'ils manquent, puis exécute les outils avec `opam exec`.

## Interface

```text
./ft_turing --help
./ft_turing machine.json input
```
