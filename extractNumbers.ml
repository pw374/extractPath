(* Lexing SVG path data

https://www.w3.org/TR/SVG/paths.html#PathDataBNF

[...] in the string "M 100-200", the first coordinate for the "moveto"
consumes the characters "100" and stops upon encountering the minus
sign because the minus sign cannot follow a digit in the production of
a "coordinate". The result is that the first coordinate will be "100"
and the second coordinate will be "-200".

Similarly, for the string "M 0.6.5", the first coordinate of the
"moveto" consumes the characters "0.6" and stops upon encountering the
second decimal point because the production of a "coordinate" only
allows one decimal point. The result is that the first coordinate will
be "0.6" and the second coordinate will be ".5".
*)

type t = token list
and token =
  | Number of float
  | Char of char

let f s =
  let is_digit = function
    | '0' .. '9' -> true
    | _ -> false in
  let rec read_next_token ?(point=false) ?(first_call=true) ?(accu="") i : int * token =
    match String.get s i with
    | '+' when first_call ->
      assert (is_digit @@ String.get s (i+1));
      read_next_token (succ i)
    | '-' when first_call ->
      assert (is_digit @@ String.get s (i+1));
      begin
        match read_next_token (succ i) with
        | i, Number t -> i, Number(-. t)
        | _ -> assert false
      end
    | '0' .. '9' as c ->
      read_next_token ~first_call:false ~accu:(accu ^ String.make 1 c) (succ i)
    | '.' as c when not point ->
      read_next_token
        ~point:true
        ~first_call:false ~accu:(accu ^ String.make 1 c) (succ i)
    | _ when not first_call ->
      succ i, Number (float_of_string accu)
    | c ->
      assert (accu="");
      succ i, Char c
  in
  let l = String.length s in
  let rec loop i res =
    if i = l then
      List.rev res
    else
      let i, t = read_next_token i in
      loop i (t::res)
  in
  loop 0 []



(* let _ = f "m 0.39129543.39128343 0 100.92575657 70.73940557 0 0 328.50186 133.898819 0 0 -55.41005 70.73942 0 0 57.38917 108.63575 0 0 57.38911 -136.42549 0 0 93.00928 -214.744856 0 0 47.49349 538.123756 0 0 61.34739 85.89759 0 0 -61.34739 156.63874 0 0 -47.49349 -156.63874 0 0 -425.46932 101.05752 0 0 -61.347407 -101.05752 0 0 " *)
