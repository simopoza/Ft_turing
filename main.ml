let usage () =
  Printf.printf "usage: ft_turing [-m max_steps] jsonfile input\n";
  exit 1

let print_trace trace =
  List.iter (fun (st, (l, h, r), (from_state, read, to_state, write, action)) ->
    let left = String.of_seq (List.to_seq (List.rev l)) in
    let right = String.of_seq (List.to_seq r) in
    let padded = right ^ String.make 13 '.' in
    let action_str = match action with Json_parser.L -> "LEFT" | Json_parser.R -> "RIGHT" in
    Printf.printf "[%s<%c>%s] (%s, %c) -> (%s, %c, %s)\n"
      left h padded from_state read to_state write action_str
  ) trace

let () =
  let max_steps = ref 10000 in
  let args = List.tl (Array.to_list Sys.argv) in
  let rec parse = function
    | "-m" :: n :: tl -> max_steps := int_of_string n; parse tl
    | [a; b] -> (a, b)
    | _ -> usage ()
  in
  let jsonfile, input = parse args in
  try
    let machine = Json_parser.parse_machine jsonfile in
    Printers.print_machine_summary machine;
    let result = Turing.run_machine ~max_steps:!max_steps machine input in
    match result with
    | `Halted trace ->
        Printf.printf "Machine halted after %d steps.\n" (List.length trace);
        print_trace trace
    | `Blocked (trace, state, (l, h, r)) ->
        Printf.printf "Machine blocked in state %s. Trace so far (%d steps)\n"
          state (List.length trace);
        List.iter (fun (st, (l, h, r), _) ->
          let left = String.of_seq (List.to_seq (List.rev l)) in
          let right = String.of_seq (List.to_seq r) in
          let padded = right ^ String.make 10 '.' in
          Printf.printf "[%s<%c>%s] (blocked in %s)\n" left h padded st
        ) trace
    | `MaxSteps trace ->
        Printf.printf "Reached max steps (%d). Trace length: %d\n"
          !max_steps (List.length trace);
        print_trace trace
  with
  | Failure s -> Printf.eprintf "Error: %s\n" s; exit 2
  | Sys_error s -> Printf.eprintf "IO Error: %s\n" s; exit 2
