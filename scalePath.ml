let error () =
  prerr_endline "first and only argument has to be the scale factor; \
                 and stdin should be the path";
  exit 1

let scale =
  try
    float_of_string Sys.argv.(1)
  with _ ->
    error ()

let path =
  let b = Buffer.create 8096 in
  try
    while true do
      Buffer.add_string b (read_line());
      Buffer.add_char b ' '
    done;
    assert false
  with End_of_file ->
    Buffer.contents b

let p = ExtractNumbers.f path

let _ =
  let open ExtractNumbers in
  List.iter (function
      | Char c -> print_char c
      | Number n -> Printf.printf "%f " @@ scale *. n
    )
    p
