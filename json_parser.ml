open Yojson.Basic.Util

type action = L | R

type transition = {
  read: char;
  to_state: string;
  write: char;
  action: action;
}

type machine = {
  name: string;
  alphabet: char list;
  blank: char;
  states: string list;
  initial: string;
  finals: string list;
  transitions: (string * transition list) list;
}

let str1 s =
  if String.length s = 1 then s.[0]
  else failwith ("Expected single-character string but got: " ^ s)

let parse_action s =
  match String.uppercase_ascii s with
  | "LEFT" | "L" -> L
  | "RIGHT" | "R" -> R
  | _ -> failwith ("Unknown action: " ^ s)

let parse_transition json =
  let read = json |> member "read" |> to_string |> str1 in
  let to_state = json |> member "to_state" |> to_string in
  let write = json |> member "write" |> to_string |> str1 in
  let action = json |> member "action" |> to_string |> parse_action in
  { read; to_state; write; action }

let parse_machine filename =
  let j = Yojson.Basic.from_file filename in
  let name = j |> member "name" |> to_string in
  let alphabet = j |> member "alphabet" |> to_list |> List.map to_string |> List.map str1 in
  let blank = j |> member "blank" |> to_string |> str1 in
  let states = j |> member "states" |> to_list |> List.map to_string in
  let initial = j |> member "initial" |> to_string in
  let finals = j |> member "finals" |> to_list |> List.map to_string in
  let transitions_obj = j |> member "transitions" in
  let transitions =
    transitions_obj
    |> to_assoc
    |> List.map (fun (state, arr) ->
           let trs = arr |> to_list |> List.map parse_transition in
           (state, trs)
       )
  in
  (* basic validation *)
  if not (List.mem blank alphabet) then failwith "blank must be in alphabet";
  if not (List.mem initial states) then failwith "initial must be in states";
  List.iter (fun f -> if not (List.mem f states) then failwith "finals must be subset of states") finals;
  { name; alphabet; blank; states; initial; finals; transitions }
