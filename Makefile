NAME = ft_turing
OPAM = opam
OCAMLOPT = ocamlopt
OCAMLC = ocamlc
OCAMLFIND = ocamlfind
PACKAGE = yojson

SOURCES = src/types.ml \
          src/tape.ml \
          src/transition.ml \
          src/parser.ml \
          src/machine.ml \
          src/main.ml

all: native

check-tools:
	@command -v $(OPAM) >/dev/null 2>&1 || { echo "Error: opam is required."; exit 1; }
	@$(OPAM) switch show >/dev/null 2>&1 || { echo "Error: an active OPAM switch is required; this Makefile will not create one automatically."; exit 1; }
	@$(OPAM) exec -- $(OCAMLOPT) -version >/dev/null 2>&1 || { echo "Error: ocamlopt is missing from the active OPAM switch."; exit 1; }
	@$(OPAM) exec -- $(OCAMLC) -version >/dev/null 2>&1 || { echo "Error: ocamlc is missing from the active OPAM switch."; exit 1; }

deps: check-tools
	@$(OPAM) exec -- $(OCAMLFIND) printconf >/dev/null 2>&1 || $(OPAM) install -y ocamlfind
	@$(OPAM) exec -- $(OCAMLFIND) query $(PACKAGE) >/dev/null 2>&1 || $(OPAM) install -y $(PACKAGE)

check-deps: check-tools
	@$(OPAM) exec -- $(OCAMLFIND) printconf >/dev/null 2>&1 || { echo "Error: ocamlfind is missing. Run 'make deps'."; exit 1; }
	@$(OPAM) exec -- $(OCAMLFIND) query $(PACKAGE) >/dev/null 2>&1 || { echo "Error: $(PACKAGE) is missing. Run 'make deps'."; exit 1; }

native: deps
	$(OPAM) exec -- $(OCAMLFIND) $(OCAMLOPT) -package $(PACKAGE) -linkpkg -I src -o $(NAME) $(SOURCES)

byte: deps
	$(OPAM) exec -- $(OCAMLFIND) $(OCAMLC) -package $(PACKAGE) -linkpkg -I src -o $(NAME).byte $(SOURCES)

test: native byte
	./$(NAME) --help >/dev/null
	./$(NAME).byte --help >/dev/null
	@echo "Help tests passed for native and bytecode executables."

clean:
	rm -f src/*.cmx src/*.cmi src/*.cmo src/*.o

fclean: clean
	rm -f $(NAME) $(NAME).byte

re: fclean all

.PHONY: all native byte test check-tools deps check-deps clean fclean re
