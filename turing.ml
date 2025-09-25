open Json_parser

type tape = char list * char * char list

let make_tape blank input =
  let chars =
    if String.length input = 0 then [blank]
    else List.init (String.length input) (fun i -> input.[i])
  in
  ([], List.hd chars, if List.length chars > 1 then List.tl chars else [])

let read_head (_, h, _) = h
let write_head (l, _, r) c = (l, c, r)

let move_left blank = function
  | ([], h, r) -> ([], blank, h :: r)
  | (lh :: lts, h, r) -> (lts, lh, h :: r)

let move_right blank = function
  | (l, h, []) -> (h :: l, blank, [])
  | (l, h, rh :: rts) -> (h :: l, rh, rts)

let find_transition transitions state ch =
  try
    let trs = List.assoc state transitions in
    Some (List.find (fun t -> t.read = ch) trs)
  with Not_found -> None

(* step now returns: new_state * new_tape * applied_transition *)
let step blank transitions (state, tape) =
  let h = read_head tape in
  match find_transition transitions state h with
  | None -> None
  | Some t ->
      let tape' = write_head tape t.write in
      let tape'' =
        match t.action with
        | L -> move_left blank tape'
        | R -> move_right blank tape'
      in
      Some (t.to_state, tape'', (state, h, t.to_state, t.write, t.action))

let run_machine ~max_steps machine input =
  let blank = machine.blank in
  let transitions = machine.transitions in
  let tape = make_tape blank input in
  let rec aux step_no state tape acc =
    if List.mem state machine.finals then (`Halted (List.rev acc))
    else if step_no >= max_steps then (`MaxSteps (List.rev acc))
    else
      match step blank transitions (state, tape) with
      | None -> `Blocked (List.rev acc, state, tape)
      | Some (state', tape', tr) ->
          aux (step_no + 1) state' tape' ((state, tape, tr) :: acc)
  in
  aux 0 machine.initial tape []
