let show_action = function
  | Json_parser.L -> "LEFT"
  | Json_parser.R -> "RIGHT"

let print_transition t =
  Printf.sprintf "(%c) -> (%s, %c, %s)"
    t.Json_parser.read t.Json_parser.to_state t.Json_parser.write (show_action t.Json_parser.action)

let print_machine_summary m =
  let alphabet = m.Json_parser.alphabet |> List.map (String.make 1) |> String.concat ", " in
  let states = String.concat ", " m.Json_parser.states in
  let finals = String.concat ", " m.Json_parser.finals in
  Printf.printf "********************************************************************************\n";
  Printf.printf "* %s *\n" m.Json_parser.name;
  Printf.printf "********************************************************************************\n";
  Printf.printf "Alphabet: [ %s ]\n" alphabet;
  Printf.printf "States : [ %s ]\n" states;
  Printf.printf "Initial : %s\n" m.Json_parser.initial;
  Printf.printf "Finals : [ %s ]\n" finals;
  Printf.printf "Transitions:\n";
  List.iter (fun (st, trs) ->
    List.iter (fun t ->
      Printf.printf "(%s, %c) -> (%s, %c, %s)\n"
        st t.Json_parser.read t.Json_parser.to_state t.Json_parser.write (show_action t.Json_parser.action)
    ) trs
  ) m.Json_parser.transitions;
  Printf.printf "********************************************************************************\n";
  ()
