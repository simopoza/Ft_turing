# ft_turing - Turing Machine Simulator (OCaml)

This project implements the **ft_turing** assignment: a simulator for single-tape,
single-head Turing machines described by a JSON file.

## Contents
- `main.ml` - command-line entrypoint.
- `json_parser.ml` - JSON parsing and validation (uses `yojson`).
- `turing.ml` - Turing machine data structures & simulator.
- `printers.ml` - pretty printing of tape and transitions.
- `Makefile` - build rules (uses `ocamlfind` + `yojson`).
- `machines/*.json` - five required machine descriptions (examples).

## Requirements
- OCaml (>= 4.08 recommended)
- opam
- `yojson` opam package

The Makefile will attempt to install `yojson` via `opam` if missing.

## Build
```bash
make

Usage
./ft_turing machines/unary_add.json "111+11"
