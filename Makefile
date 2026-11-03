NAME = ft_turing
OCAMLOPT = ocamlopt
OCAMLC = ocamlc
SOURCES = src/tape.ml \
          src/head.ml \
          src/state.ml \
          src/transition.ml \
          src/parser.ml \
          src/machine.ml \
          src/main.ml

all: native

native:
	ocamlfind $(OCAMLOPT) -package yojson -linkpkg -I src -o $(NAME) $(SOURCES)

byte:
	ocamlfind $(OCAMLC) -package yojson -linkpkg -I src -o $(NAME) $(SOURCES)

clean:
	rm -f src/*.cmx src/*.cmi src/*.cmo src/*.o

fclean: clean
	rm -f $(NAME)

re: fclean all

.PHONY: all native byte clean fclean re
