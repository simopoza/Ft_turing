
---

## 📄 `Makefile`
```make
OCAMLFIND=ocamlfind
PKG=yojson

all: ft_turing

.PHONY: deps
deps:
	@if ! opam list --installed --short | grep -q "^$(PKG)$$"; then \
		echo "Installing $(PKG) via opam..."; \
		opam install -y $(PKG); \
	else \
		echo "$(PKG) already installed."; \
	fi

ft_turing: deps
	$(OCAMLFIND) ocamlopt -linkpkg -package $(PKG) json_parser.ml turing.ml printers.ml main.ml -o ft_turing

clean:
	rm -f *.cm* *.o ft_turing

.PHONY: all clean deps
