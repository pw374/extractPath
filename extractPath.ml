let usage i =
  Printf.eprintf "Usage: %s file1.svg [file2.svg ...]\n\
will print all paths of given files; each path is separated by a simple space.\n\
\nHope that helps!\n" Sys.argv.(0);
  exit i

let _ =
  for i = 1 to Array.length Sys.argv - 1 do
    if not (Sys.file_exists (Sys.argv.(i))) then
      usage 1
  done


let extract_path attributes =
  List.iter (function
  | ("", "d"), path -> Printf.printf "%s " path
  | _ -> ()
  ) attributes

let _ =
  try
    for i = 1 to Array.length Sys.argv - 1 do
      try
        let i = Xmlm.make_input (`Channel (open_in_bin Sys.argv.(i))) in
        while true do
          match Xmlm.input i with
          | `El_start ((_, "path"), attributes) ->
            extract_path attributes
          | `El_end ->
            if Xmlm.eoi i then raise End_of_file
          | _ -> ()
        done
      with
      | End_of_file ->
        print_newline()
      | Xmlm.Error ((posl, posc), e) ->
        Printf.eprintf "Error: file <%S>@(%d, %d): %s\n%!"
          Sys.argv.(i) posl posc
          (Xmlm.error_message e);
        exit 1
    done
  with
  | e ->
    Printf.eprintf "Error: %s\n%!" (Printexc.to_string e);
    exit 2

